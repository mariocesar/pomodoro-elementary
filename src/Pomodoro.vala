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

namespace Pomodoro {

  public class PomodoroApp : Granite.Application {
    private PomodoroWindow window = null;

    construct {
        program_name = "Pomodoro";
        exec_name = "pomodoro";
        app_years = "2014";
        app_icon = "preferences-system-time";
        app_launcher = "pomodoro.desktop";
        application_id = "net.launchpad.pomodoro-app";
        main_url = "https://github.com/mariocesar/pomodoro-elementary";
        help_url = "https://github.com/mariocesar/pomodoro-elementary/issues";
        about_authors = {"Mario César Señoranis Ayala <mariocesar@creat1va.com>", null };
        about_license_type = Gtk.License.GPL_3_0;
    }  
    
    protected override void activate () {
      window = new PomodoroWindow();
      window.show();
      add_window(window);
    }

  }
 
  public static int main (string[] args) {
    var app = new PomodoroApp();
    return app.run(args);
  }
}