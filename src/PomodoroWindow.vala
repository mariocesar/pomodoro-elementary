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
    private Gtk.HeaderBar toolbar;
    private Pomodoro.TimeDisplay time_display;
    private TrackerManager tracker;

    private Gtk.Grid main_layout;
    private Gtk.Button start_button;
    private Gtk.Button stop_button;
    private Gtk.Button pause_button;

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

        tracker = new TrackerManager();
        time_display = new Pomodoro.TimeDisplay();
        start_button = new Gtk.Button.with_label("start");
        stop_button = new Gtk.Button.with_label("stop");
        pause_button = new Gtk.Button.with_label("pause");

        start_button.clicked.connect(() => {
            tracker.start();
        });
        stop_button.clicked.connect(() => {
            tracker.stop();
            time_display.set_text(tracker.elapsed.short_string());
        });
        pause_button.clicked.connect(() => {
            tracker.pause();
        });

        main_layout = new Gtk.Grid();
        main_layout.expand = true;
        main_layout.orientation = Gtk.Orientation.VERTICAL;

        main_layout.add(time_display);
        main_layout.add(start_button);
        main_layout.add(stop_button);
        main_layout.add(pause_button);

        add(main_layout);
        update_time_display();

        show_all();
    }

    private void update_time_display() {
        // TODO: Update the display just when the widget is show to the user
        Timeout.add(250, ()=>{
            time_display.set_text(tracker.elapsed.short_string());
            return true;
        });
    }
  }
}