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

    themeFile = "Catppuccin-Macchiato";
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
    };
  };
}
