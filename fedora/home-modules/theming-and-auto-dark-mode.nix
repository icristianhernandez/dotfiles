{ pkgs, guardRole, ... }:

let
  applyTheme =
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

    darkModeScripts.unified-theme = applyTheme {
      colorScheme = "prefer-dark";
      gtk = "Adwaita-dark";
      icon = "Tela-circle-dark";
      cursor = "Simp1e-Adw";
    };

    lightModeScripts.unified-theme = applyTheme {
      colorScheme = "default";
      gtk = "Adwaita";
      icon = "Tela-circle";
      cursor = "Simp1e-Adw-Dark";
    };
  };

}
