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
  public class PomodoroWindow : Gtk.Dialog {
    private Gtk.HeaderBar toolbar;

    public PomodoroWindow () {
      toolbar = new Gtk.HeaderBar ();
      toolbar.show_close_button = true;
      toolbar.set_title("Pomodoro");
      toolbar.set_decoration_layout("close:");

      var screen = this.get_screen();
      var css_provider = new Gtk.CssProvider();
      css_provider.load_from_path ("../share/style/default.css");

      this.get_style_context().add_class("PomodoroWindow");
      
      var context = new Gtk.StyleContext();
      context.add_provider_for_screen(screen, css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

      this.set_titlebar (toolbar);
      this.set_size_request (480, 480);
      this.show_all();
    }

  }
}