let
  cursorSize = 32;
  cursorName = "Yaru";
  fontName = "Inter";
  monospaceFontName = "JetBrainsMono Nerd Font";
  fontSize = 11;
in
{
  inherit cursorSize cursorName;

  fonts = {
    regular = "${fontName} ${builtins.toJSON fontSize}";
    document = "${fontName} ${builtins.toJSON fontSize}";
    monospace = "${monospaceFontName} ${builtins.toJSON (fontSize + 1.5)}";
    titlebar = "${fontName} Bold ${builtins.toJSON (fontSize + 1)}";
  };

  packages = {
    cursorTheme = "yaru-theme";
  };

  gtk = {
    dark = {
      colorScheme = "prefer-dark";
      theme = "Yaru-dark";
      # shellTheme = "Yaru-dark";
      shellTheme = "Default";
      accentColor = "blue";
      iconTheme = "Yaru-dark";
      cursorTheme = "Yaru";
    };

    light = {
      colorScheme = "default";
      theme = "Yaru";
      # shellTheme = "Yaru";
      shellTheme = "Default";
      accentColor = "blue";
      iconTheme = "Yaru";
      cursorTheme = "Yaru";
    };
  };
}
