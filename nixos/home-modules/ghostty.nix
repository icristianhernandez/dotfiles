{
  guardRole,
  ...
}:

guardRole "desktop" {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 14;

      "keybind" = [
        "performable:ctrl+c=copy_to_clipboard"
        "performable:ctrl+v=paste_from_clipboard"
        "f11=toggle_fullscreen"
        "ctrl+plus=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+enter=none"
      ];

      window-decoration = true;
    };
  };

  home.file.".config/ghostty/themes/catppuccin-mocha.conf" = {
    text = ''
      palette = 0=#45475a
      palette = 1=#f38ba8
      palette = 2=#a6e3a1
      palette = 3=#f9e2af
      palette = 4=#89b4fa
      palette = 5=#f5c2e7
      palette = 6=#94e2d5
      palette = 7=#a6adc8
      palette = 8=#585b70
      palette = 9=#f38ba8
      palette = 10=#a6e3a1
      palette = 11=#f9e2af
      palette = 12=#89b4fa
      palette = 13=#f5c2e7
      palette = 14=#94e2d5
      palette = 15=#bac2de
      background = 1e1e2e
      foreground = cdd6f4
      cursor-color = f5e0dc
      cursor-text = 11111b
      selection-background = 353749
      selection-foreground = cdd6f4
      split-divider-color = 313244
    '';
  };

  home.file.".config/ghostty/themes/catppuccin-mocha" = {
    text = ''
      palette = 0=#45475a
      palette = 1=#f38ba8
      palette = 2=#a6e3a1
      palette = 3=#f9e2af
      palette = 4=#89b4fa
      palette = 5=#f5c2e7
      palette = 6=#94e2d5
      palette = 7=#a6adc8
      palette = 8=#585b70
      palette = 9=#f38ba8
      palette = 10=#a6e3a1
      palette = 11=#f9e2af
      palette = 12=#89b4fa
      palette = 13=#f5c2e7
      palette = 14=#94e2d5
      palette = 15=#bac2de
      background = 1e1e2e
      foreground = cdd6f4
      cursor-color = f5e0dc
      cursor-text = 11111b
      selection-background = 353749
      selection-foreground = cdd6f4
      split-divider-color = 313244
    '';
  };
}
