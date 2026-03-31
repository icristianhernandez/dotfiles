{
  lib,
  pkgs,
  guardRoles,
  hasRole,
  ...
}:

let
  theme = import ../lib/theme.nix;

  applyGtkTheme = profile: ''
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'${profile.colorScheme}'"
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'${profile.theme}'"
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/icon-theme "'${profile.iconTheme}'"
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/cursor-theme "'${profile.cursorTheme}'"
  '';

  applyPlasmaTheme = profile: ''
    ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme ${lib.escapeShellArg profile.colorScheme}
    ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-desktoptheme ${lib.escapeShellArg profile.desktopTheme}
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kdeglobals --group Icons --key Theme ${lib.escapeShellArg profile.iconTheme}
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme ${lib.escapeShellArg profile.cursorTheme}
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kcminputrc --group Mouse --key cursorSize ${toString theme.cursorSize}
    ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-cursortheme --size ${toString theme.cursorSize} ${lib.escapeShellArg profile.cursorTheme}
  '';

  plasmaDarkModeScripts =
    if hasRole "plasma" then
      {
        plasma-theme = applyPlasmaTheme theme.plasma.dark;
      }
    else
      { };

  plasmaLightModeScripts =
    if hasRole "plasma" then
      {
        plasma-theme = applyPlasmaTheme theme.plasma.light;
      }
    else
      { };
in
guardRoles
  {
    include = [ "desktop" ];
    exclude = [ "plasma" ];
  }
  {
    home = {
      packages = [
        pkgs.${theme.packages.iconTheme}
        pkgs.${theme.packages.cursorTheme}
      ];

      pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.${theme.packages.cursorTheme};
        name = theme.cursorName;
        size = theme.cursorSize;
      };
    };

    services.darkman = {
      enable = true;
      settings = {
        lat = 10.5;
        lng = -66.9;
        usegeoclue = false;
        portal = false;
      };

      darkModeScripts = {
        gtk-theme = applyGtkTheme theme.gtk.dark;
      }
      // plasmaDarkModeScripts;

      lightModeScripts = {
        gtk-theme = applyGtkTheme theme.gtk.light;
      }
      // plasmaLightModeScripts;
    };
  }
