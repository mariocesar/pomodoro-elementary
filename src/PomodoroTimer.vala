// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/***
  BEGIN LICENSE

  Copyright (C) 2014 Mario César Señoranis Ayala <mariocesar@creat1va.com>
  This program is free software: you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License version 3, as
  published by the Free Software Foundation.

  This program is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranties of
  MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
  PURPOSE.  See the GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along
  with this program.  If not, see <http://www.gnu.org/licenses>

  END LICENSE
***/

public class Pomodoro.Bell : Object {
    private Canberra.Context? canberra;
    private string sound;
    private Notify.Notification? notification;

    public delegate void ActionCallback ();

    public Bell (string soundid, string title, string msg) {
        if (Canberra.Context.create (out canberra) < 0) {
            warning ("Sound will not be available");
            canberra = null;
        }

        sound = soundid;
        notification = null;

        if (Notify.is_initted() || Notify.init ("GNOME Clocks")) {
            notification = new Notify.Notification (title, msg, "gnome-clocks");
            notification.set_hint_string ("desktop-entry", "gnome-clocks");
        } else {
            warning ("Could not initialize notification");
        }
    }

    private bool keep_ringing () {
        Canberra.Proplist pl;
        Canberra.Proplist.create (out pl);
        pl.sets (Canberra.PROP_EVENT_ID, sound);
        pl.sets (Canberra.PROP_MEDIA_ROLE, "alarm");

        canberra.play_full (1, pl, (c, id, code) => {
            if (code == Canberra.SUCCESS) {
                GLib.Idle.add (keep_ringing);
            }
        });

        return false;
    }

    private void ring_real (bool once) {
        if (canberra != null) {
            if (once) {
                canberra.play (1,
                               Canberra.PROP_EVENT_ID, sound,
                               Canberra.PROP_MEDIA_ROLE, "alarm");
            } else {
                GLib.Idle.add (keep_ringing);
            }
        }

        if (notification != null) {
            try {
                notification.show ();
            } catch (GLib.Error error) {
                warning (error.message);
            }
        }
    }

    public void ring_once () {
        ring_real (true);
    }

    public void ring () {
        ring_real (false);
    }

    public void stop () {
        if (canberra != null) {
            canberra.cancel (1);
        }
    }

    public void add_action (string action, string label, owned ActionCallback callback) {
        if (notification != null) {
            notification.add_action (action, label, (n, a) => {
                callback ();
            });
        }
    }
}


public class Pomodoro.Timer : Object {

    public struct Elapsed {
        public int hours;
        public int minutes;
        public int seconds;

        public new string to_string() {
            return (@"$(hours) hours, $(minutes) minutes and $(seconds) seconds");
        }

        public new string short_string() {
            if (hours > 0) {
                return "%02d:%02d".printf(hours, minutes);
            } else{
                return "%02d:%02d".printf(minutes, seconds);
            }
        }
    }

    public enum State {
        STOPPED,
        RUNNING,
        PAUSED
    }

    private GLib.Timer timer;
    private Pomodoro.Bell bell_done;
    // private Pomodoro.Bell bell_alert;

    public signal void timer_stopped (bool was_running=false);
    public signal void timer_started (bool was_paused=false);
    public signal void timer_paused ();
    public State state { get; private set; default = State.STOPPED; }

    public Timer() {
        timer = new GLib.Timer();

        bell_done = new Pomodoro.Bell ("complete", "Time is up!", "Timer countdown finished");
        // bell_alert = new Pomodoro.Bell ("alarm-clock-elapsed", "Alarm", "Alarm");
    }

    public void start() {
        if (state == State.RUNNING) { return; }
        if (state == State.PAUSED) {
            timer.continue();
            timer_started(true);
            debug("Continue timer");
        } else {
            timer.start();
            timer_started();
            debug("Start timer");
        }

        bell_done.ring_once ();

        state = State.RUNNING;
    }

    public void pause() {
        if (state == State.PAUSED) { return; }
        state = State.PAUSED;

        timer.stop();
        timer_paused();

        debug("Pause timer");
    }

    public void stop() {

        var was_running = state == State.RUNNING ? true : false;

        state = State.STOPPED;
        timer.stop();

        timer_stopped( was_running );

        debug(@"Stop timer. running=$was_running");
    }

    public Elapsed get_elapsed() {

        var total_seconds = (int) timer.elapsed();
        var total_minutes = (int) total_seconds / 60;
        var total_hours = (int) total_seconds / (60 * 60);

        var elapsed = Elapsed() {
            seconds = (int) total_seconds % 60,
            minutes = (int) total_minutes % 60,
            hours = (int) total_hours % 24
        };

        // debug("%s: %s".printf("%f".printf(timer.elapsed()) , elapsed.to_string()));

        return elapsed;
    }
}
