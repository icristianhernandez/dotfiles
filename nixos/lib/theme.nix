let
  cursorSize = 32;
  cursorName = "Simp1e-Adw";
in
{
  inherit cursorSize cursorName;

  packages = {
    iconTheme = "tela-circle-icon-theme";
    cursorTheme = "simp1e-cursors";
  };

  gtk = {
    dark = {
      colorScheme = "prefer-dark";
      theme = "Adwaita-dark";
      iconTheme = "Tela-circle-dark";
      cursorTheme = "Simp1e-Adw";
    };

    light = {
      colorScheme = "default";
      theme = "Adwaita";
      iconTheme = "Tela-circle";
      cursorTheme = "Simp1e-Adw-Dark";
    };
  };

  plasma = {
    dark = {
      colorScheme = "BreezeDark";
      desktopTheme = "breeze-dark";
      iconTheme = "Tela-circle-dark";
      cursorTheme = "Simp1e-Adw";
    };

    light = {
      colorScheme = "BreezeLight";
      desktopTheme = "breeze-light";
      iconTheme = "Tela-circle";
      cursorTheme = "Simp1e-Adw-Dark";
    };
  };
}
