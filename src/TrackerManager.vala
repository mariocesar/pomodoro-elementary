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
        return "%02d:%02d".printf(minutes, seconds);
    }
}

namespace Pomodoro {

    public class TrackerManager : Object {
        private Timer timer;

        public Elapsed elapsed = Elapsed() {
            hours = 0, minutes = 0, seconds = 0
        };

        private bool running {get; private set; default = false;}
        private bool paused {get; private set; default = false;}

        public TrackerManager() {
            timer = new Timer();
        }

        public void start() {
            if (paused) {
                timer.continue();
                debug("Continue tracker");
            } else {
                timer.start();
                debug("Start tracker");
            }

            paused = false;
            running = true;
            Timeout.add(75, thick);
        }

        public void pause() {
            paused = true;
            running = false;
            timer.stop();
        }

        public void reset() {
            timer.stop();
            running = false;
            paused = false;
        }

        private bool thick() {
            if (!running) {
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

            //debug("%s: %s".printf("%f".printf(timer.elapsed()) , elapsed.to_string()));

            return true;
        }
    }
}