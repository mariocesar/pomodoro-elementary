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
    public class PomodoroApp : Granite.Application {
        private PomodoroWindow window;

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

        public void load_css_styles() {
            // TODO: Fail loudly if the styles can't be loaded
            try {
                var css_provider = new CssProvider();
                css_provider.load_from_path("share/style/default.css");

                Gtk.StyleContext.add_provider_for_screen(
                    Gdk.Screen.get_default (),
                    css_provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            } catch (GLib.Error e) {
                 warning ("Error while loading style/default.css: %s", e.message);
            }

            // var settings = Gtk.Settings.get_default ();
            // settings.gtk_application_prefer_dark_theme = true;
        }

        protected override void activate () {

            if (window != null) {
                window.present ();
                return;
            }

            Granite.Services.Logger.DisplayLevel = Granite.Services.LogLevel.DEBUG;

            load_css_styles();

            window = new PomodoroWindow(this);
            window.destroy.connect (() => {
                window = null;
            });

        }

    }

    public static int main (string[] args) {
        var app = new PomodoroApp();
        return app.run(args);
    }
}