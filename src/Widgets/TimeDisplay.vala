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

    public class TimeDisplay : Gtk.Label {
        private Pomodoro.Timer timer;
        private uint tick_id = 0;

        public TimeDisplay(Pomodoro.Timer timer) {
            this.timer = timer;

            expand = true;
            get_style_context().add_class("TimeDisplay");
            reset_text();
        }

        public uint get_tick_id() {
            return tick_id;
        }

        public void reset_text() {
            set_text("00:00");
        }

        private void update_text(Pomodoro.Timer.Elapsed elapsed) {
            set_text(elapsed.short_string());

            if (get_mapped()) {
                queue_draw();
            }
        }

        public bool tick() {
            var elapsed = timer.get_elapsed ();
            update_text(elapsed);
            return true;

        }

        public void add_tick () {
            if (tick_id == 0) {
                tick_id = add_tick_callback ((c) => {
                    return tick();
                });
            }
        }

        public void remove_tick () {
            if (tick_id != 0) {
                remove_tick_callback (tick_id);
                tick_id = 0;
            }
        }
    }
}