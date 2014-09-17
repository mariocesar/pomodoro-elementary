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

using Gtk;

namespace Pomodoro {

  public class PomodoroWindow : Gtk.Window {
    private Pomodoro.TimeDisplay time_display;
    private Pomodoro.Timer timer;

    private Gtk.HeaderBar toolbar;
    private Gtk.Grid main_layout;
    private Gtk.Grid control_layout;
    private Gtk.Button play_button;
    private Gtk.Button stop_button;

    public PomodoroWindow (Gtk.Application app) {
        Object (application: app);

        toolbar = new Gtk.HeaderBar();
        toolbar.show_close_button = true;
        toolbar.set_title("Pomodoro");
        // toolbar.set_decoration_layout("close:");
        set_titlebar(toolbar);

        icon_name = "preferences-system-time";
        border_width = 5;
        resizable = false;
        set_size_request(480, 480);

        timer = new Pomodoro.Timer();
        timer.timer_paused.connect(timer_paused);
        timer.timer_started.connect(timer_started);
        timer.timer_stopped.connect(timer_stoped);

        time_display = new Pomodoro.TimeDisplay();

        play_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
        play_button.expand = true;
        play_button.set_tooltip_text ("Start");

        stop_button = new Gtk.Button.from_icon_name ("media-playback-stop-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
        stop_button.expand = true;
        stop_button.set_tooltip_text ("Stop");

        play_button.clicked.connect(() => {start_pause_timer();});

        stop_button.clicked.connect(() => {stop_timer();});

        main_layout = new Gtk.Grid();
        main_layout.expand = true;
        main_layout.orientation = Gtk.Orientation.VERTICAL;

        control_layout = new Gtk.Grid();
        control_layout.vexpand = false;
        control_layout.orientation = Gtk.Orientation.HORIZONTAL;

        control_layout.add(play_button);
        control_layout.add(stop_button);

        main_layout.add(time_display);
        main_layout.add(control_layout);

        add(main_layout);
        update_time_display();

        show_all();
    }
    public virtual void timer_started () {
        play_button.set_image (new Gtk.Image.from_icon_name ("media-playback-pause-symbolic", Gtk.IconSize.LARGE_TOOLBAR));
        play_button.set_tooltip_text ("Pause");
    }

    public virtual void timer_paused () {
        play_button.set_image (new Gtk.Image.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.LARGE_TOOLBAR));
        play_button.set_tooltip_text ("Start");
    }

    public virtual void timer_stoped (bool was_running) {
        if (was_running) {
            timer_paused();
        }

        time_display.set_text(timer.elapsed.short_string());
    }

    public virtual void start_pause_timer () {
        switch (timer.state) {
            case Pomodoro.Timer.State.RUNNING:
                timer.pause();
                break;
            case Pomodoro.Timer.State.STOPPED:
                timer.start();
                break;
            case Pomodoro.Timer.State.PAUSED:
                timer.start();
                break;
        }
    }

    public virtual void stop_timer() {
        timer.stop();
    }

    private void update_time_display() {
        // TODO: Update the display just when the widget is show to the user
        Timeout.add(250, ()=>{
            time_display.set_text(timer.elapsed.short_string());
            return true;
        });
    }
  }
}