{
  pkgs,
  guardRole,
  hasRole,
  ...
}:

let
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

  applyPlasmaTheme =
    {
      colorScheme,
      desktopTheme,
      iconTheme,
      cursorTheme,
      cursorSize,
    }:
    ''
      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme ${colorScheme}
      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-desktoptheme ${desktopTheme}
      ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kdeglobals --group Icons --key Theme ${iconTheme}
      ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-cursortheme --size ${toString cursorSize} ${cursorTheme}
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
      name = "Simp1e-Adw";
      size = 36;
    };
  };

  services.darkman = {
    enable = true;
    settings = {
      lat = 10.5;
      lng = -66.9;
      usegeoclue = false;
      portal = true;
    };

    darkModeScripts = {
      unified-theme = applyGnomeTheme {
        colorScheme = "prefer-dark";
        gtk = "Adwaita-dark";
        icon = "Tela-circle-dark";
        cursor = "Simp1e-Adw";
      };
    }
    // (
      if hasRole "plasma" then
        {
          plasma-theme = applyPlasmaTheme {
            colorScheme = "BreezeDark";
            desktopTheme = "breeze-dark";
            iconTheme = "Tela-circle-dark";
            cursorTheme = "Simp1e-Adw";
            cursorSize = 36;
          };
        }
      else
        { }
    );

    lightModeScripts = {
      unified-theme = applyGnomeTheme {
        colorScheme = "default";
        gtk = "Adwaita";
        icon = "Tela-circle";
        cursor = "Simp1e-Adw-Dark";
      };
    }
    // (
      if hasRole "plasma" then
        {
          plasma-theme = applyPlasmaTheme {
            colorScheme = "BreezeLight";
            desktopTheme = "breeze";
            iconTheme = "Tela-circle";
            cursorTheme = "Simp1e-Adw-Dark";
            cursorSize = 36;
          };
        }
      else
        { }
    );
  };
}
