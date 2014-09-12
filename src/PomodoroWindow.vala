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

    public PomodoroWindow () {

        toolbar = new Gtk.HeaderBar();
        toolbar.show_close_button = true;
        toolbar.set_title("Pomodoro");
        // toolbar.set_decoration_layout("close:");
        set_titlebar(toolbar);

        icon_name = "preferences-system-time";
        border_width = 5;
        resizable = false;
        set_size_request(480, 480);

        var main_layout = new Gtk.Grid ();
        main_layout.expand = true;
        main_layout.orientation = Gtk.Orientation.VERTICAL;

        tracker = new TrackerManager();
        tracker.start();

        time_display = new Pomodoro.TimeDisplay();
        main_layout.add(time_display);
        add(main_layout);
        show_all();

        update_time_display();
    }

    private void update_time_display() {
        // TODO: Update the display just when the widget is show to the user
        Timeout.add(500, ()=>{
            time_display.set_text(tracker.elapsed.short_string());
            return true;
        });
    }
  }
}