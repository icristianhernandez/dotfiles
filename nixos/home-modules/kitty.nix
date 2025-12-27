{
  guardRole,
  ...
}:

guardRole "desktop" {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };

    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
      "f11" = "toggle_fullscreen";
      "ctrl++" = "increase_font_size";
      "ctrl+-" = "decrease_font_size";
    };

    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      allow_remote_control = "yes";
      wayland_titlebar_color = "system";
    };
  };

  home.file = {
    ".config/kitty/themes/catppuccin-frappe.conf".text = ''
      # vim:ft=kitty

      ## name:     Catppuccin Kitty Frappé
      ## author:   Catppuccin Org
      ## license:  MIT
      ## upstream: https://github.com/catppuccin/kitty/blob/main/themes/frappe.conf
      ## blurb:    Soothing pastel theme for the high-spirited!


      # The basic colors
      foreground              #c6d0f5
      background              #303446
      selection_foreground    #303446
      selection_background    #f2d5cf

      # Cursor colors
      cursor                  #f2d5cf
      cursor_text_color       #303446

      # URL underline color when hovering with mouse
      url_color               #f2d5cf

      # Kitty window border colors
      active_border_color     #babbf1
      inactive_border_color   #737994
      bell_border_color       #e5c890

      # OS Window titlebar colors
      wayland_titlebar_color system
      macos_titlebar_color system

      # Tab bar colors
      active_tab_foreground   #232634
      active_tab_background   #ca9ee6
      inactive_tab_foreground #c6d0f5
      inactive_tab_background #292c3c
      tab_bar_background      #232634

      # Colors for marks (marked text in the terminal)
      mark1_foreground #303446
      mark1_background #babbf1
      mark2_foreground #303446
      mark2_background #ca9ee6
      mark3_foreground #303446
      mark3_background #85c1dc

      # The 16 terminal colors

      # black
      color0 #51576d
      color8 #626880

      # red
      color1 #e78284
      color9 #e78284

      # green
      color2  #a6d189
      color10 #a6d189

      # yellow
      color3  #e5c890
      color11 #e5c890

      # blue
      color4  #8caaee
      color12 #8caaee

      # magenta
      color5  #f4b8e4
      color13 #f4b8e4

      # cyan
      color6  #81c8be
      color14 #81c8be

      # white
      color7  #b5bfe2
      color15 #a5adce
    '';

    ".config/kitty/themes/catppuccin-latte.conf".text = ''
      # vim:ft=kitty

      ## name:     Catppuccin Kitty Latte
      ## author:   Catppuccin Org
      ## license:  MIT
      ## upstream: https://github.com/catppuccin/kitty/blob/main/themes/latte.conf
      ## blurb:    Soothing pastel theme for the high-spirited!


      # The basic colors
      foreground              #4c4f69
      background              #eff1f5
      selection_foreground    #eff1f5
      selection_background    #dc8a78

      # Cursor colors
      cursor                  #dc8a78
      cursor_text_color       #eff1f5

      # URL underline color when hovering with mouse
      url_color               #dc8a78

      # Kitty window border colors
      active_border_color     #7287fd
      inactive_border_color   #9ca0b0
      bell_border_color       #df8e1d

      # OS Window titlebar colors
      wayland_titlebar_color system
      macos_titlebar_color system

      # Tab bar colors
      active_tab_foreground   #eff1f5
      active_tab_background   #8839ef
      inactive_tab_foreground #4c4f69
      inactive_tab_background #9ca0b0
      tab_bar_background      #bcc0cc

      # Colors for marks (marked text in the terminal)
      mark1_foreground #eff1f5
      mark1_background #7287fd
      mark2_foreground #eff1f5
      mark2_background #8839ef
      mark3_foreground #eff1f5
      mark3_background #209fb5

      # The 16 terminal colors

      # black
      color0 #5c5f77
      color8 #6c6f85

      # red
      color1 #d20f39
      color9 #d20f39

      # green
      color2  #40a02b
      color10 #40a02b

      # yellow
      color3  #df8e1d
      color11 #df8e1d

      # blue
      color4  #1e66f5
      color12 #1e66f5

      # magenta
      color5  #ea76cb
      color13 #ea76cb

      # cyan
      color6  #179299
      color14 #179299

      # white
      color7  #acb0be
      color15 #bcc0cc
    '';

    ".config/kitty/dark-theme.auto.conf".text = ''
      include ~/.config/kitty/themes/catppuccin-frappe.conf
    '';

    ".config/kitty/light-theme.auto.conf".text = ''
      include ~/.config/kitty/themes/catppuccin-latte.conf
    '';

    ".config/kitty/no-preference-theme.auto.conf".text = ''
      include ~/.config/kitty/themes/catppuccin-latte.conf
    '';
  };
}
