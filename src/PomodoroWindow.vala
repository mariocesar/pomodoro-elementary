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
    private Gtk.SizeGroup sg;

    public PomodoroWindow () {
      toolbar = new Gtk.HeaderBar();
      toolbar.show_close_button = false;
      toolbar.set_title("Pomodoro");
      // toolbar.set_decoration_layout("close:");
      set_titlebar(toolbar);    

      var screen = this.get_screen();
      var css_provider = new Gtk.CssProvider();
      css_provider.load_from_path("../share/style/default.css");
      var context = new Gtk.StyleContext();
      context.add_provider_for_screen(screen, css_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

      /*
      get_style_context().add_class("PomodoroWindow");
      */

      /*
      Gtk.Box header = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
      header.height_request = 15;
      set_titlebar(header);
      */
      border_width = 5;
      resizable = false;
      set_size_request(480, 480);
      // set_default_size(480, -1);

      var content_area = get_content_area ();
      sg = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);

      var content_vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
      //var content_vbox = new VBox(false, 12);
      content_area.pack_start (content_vbox);

      // Adjust sizes
      content_vbox.margin_right = 5;
      content_vbox.margin_left = 5;
      
      var time_display = new Pomodoro.TimeDisplay();
      content_vbox.pack_start (time_display, true, true, 0);

      // Close button
      add_button ("Close", Gtk.ResponseType.CLOSE);
      response.connect ((source, type) => {
          switch (type) {
              case Gtk.ResponseType.CLOSE:
                  destroy ();
                  break;
          }
      });

      show_all();
    }
  }
}