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


public class Pomodoro.Phases : Object {

}

public class Pomodoro.Timer : Object {
    public enum State {
        STOPPED,
        RUNNING,
        PAUSED
    }

    private GLib.Timer timer;

    public signal void timer_stopped (bool was_running=false);
    public signal void timer_started (bool was_paused=false);
    public signal void timer_paused ();

    public State state { get; private set; default = State.STOPPED; }
    public Elapsed elapsed = Elapsed() {
        hours = 0, minutes = 0, seconds = 0
    };

    public Timer() { timer = new GLib.Timer(); }

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

        state = State.RUNNING;

        Timeout.add(75, tick);
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

        elapsed = Elapsed() {
            seconds = 0,
            minutes = 0,
            hours = 0
        };

        state = State.STOPPED;
        timer.stop();

        timer_stopped( was_running );

        debug(@"Stop timer. running=$was_running");
    }

    private bool tick() {
        if (state == State.STOPPED) {
            return false;
        }

        var total_seconds = (int) timer.elapsed();
        var total_minutes = (int) total_seconds / 60;
        var total_hours = (int) total_seconds / (60 * 60);

        elapsed = Elapsed() {
            seconds = (int) total_seconds % 60,
            minutes = (int) total_minutes % 60,
            hours = (int) total_hours % 24
        };

        // debug("%s: %s".printf("%f".printf(timer.elapsed()) , elapsed.to_string()));

        return true;
    }
}
