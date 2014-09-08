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
        construct {
            build_data_dir = Constants.DATADIR;
            build_pkg_data_dir = Constants.PKGDATADIR;
            build_release_name = Constants.RELEASE_NAME;
            build_version = Constants.VERSION;
            build_version_info = Constants.VERSION_INFO;

            program_name = "Pomodoro";
            exec_name = "pomodoro";
            app_years = "2014";
            app_icon = "pomodoro-app";
            app_launcher = "pomodoro.desktop";
            application_id = "net.launchpad.pomodoro-app";
            main_url = "https://github.com/mariocesar/pomodoro-elementary";
            help_url = "https://github.com/mariocesar/pomodoro-elementary/issues";
            about_authors = {"Mario César Señoranis Ayala <mariocesar@creat1va.com>", null };
            about_license_type = Gtk.License.GPL_3_0;
        }
    }

    public static int main (string[] args) {
        var application = PomodoroApp();
        return app.run(args);
    }
}