{
  pkgs,
  guardRole,
  hasRole,
  ...
}:

let
  # GNOME theme application via dconf
  applyGnomeTheme =
    {
      colorScheme,
      gtk,
      icon,
      cursor,
    }:
    ''
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'${colorScheme}'"
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'${gtk}'"
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/icon-theme "'${icon}'"
      ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/cursor-theme "'${cursor}'"
    '';

  # Plasma theme application via plasma-apply-* commands
  applyPlasmaTheme =
    {
      colorScheme,
      icon,
      cursor,
    }:
    ''
      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme ${colorScheme}
      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-desktoptheme ${
        if colorScheme == "BreezeDark" then "breeze-dark" else "breeze-light"
      }
      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-cursortheme ${cursor}
      # Icon theme change requires kwriteconfig6
      ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kdeglobals --group Icons --key Theme "${icon}"
    '';

  isGnome = hasRole "gnome";
  isPlasma = hasRole "plasma";
in
guardRole "desktop" {
  home = {
    packages = with pkgs; [
      tela-circle-icon-theme
      simp1e-cursors
    ];

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.simp1e-cursors;
      name = "Simp1e-Adw-Dark";
      size = 34;
    };
  };

  services.darkman = {
    enable = true;
    settings = {
      lat = 10.5;
      lng = -66.9;
      usegeoclue = false;
    };

    darkModeScripts.unified-theme =
      if isGnome then
        applyGnomeTheme {
          colorScheme = "prefer-dark";
          gtk = "Adwaita-dark";
          icon = "Tela-circle-dark";
          cursor = "Simp1e-Adw";
        }
      else if isPlasma then
        applyPlasmaTheme {
          colorScheme = "BreezeDark";
          icon = "Tela-circle-dark";
          cursor = "Simp1e-Adw";
        }
      else
        "";

    lightModeScripts.unified-theme =
      if isGnome then
        applyGnomeTheme {
          colorScheme = "default";
          gtk = "Adwaita";
          icon = "Tela-circle";
          cursor = "Simp1e-Adw-Dark";
        }
      else if isPlasma then
        applyPlasmaTheme {
          colorScheme = "BreezeLight";
          icon = "Tela-circle";
          cursor = "Simp1e-Adw-Dark";
        }
      else
        "";
  };

}
