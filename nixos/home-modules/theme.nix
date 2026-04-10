{
  pkgs,
  guardRoles,
  ...
}:

let
  theme = import ../lib/theme.nix;

  applyGtkTheme = profile: ''
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'${profile.colorScheme}'"
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'${profile.theme}'"
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/accent-color "'${profile.accentColor}'"
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/icon-theme "'${profile.iconTheme}'"
    ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/cursor-theme "'${profile.cursorTheme}'"
    ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/user-theme/name "'${profile.shellTheme}'"
  '';
in
guardRoles
  {
    include = [ "desktop" ];
    exclude = [ "plasma" ];
  }
  {
    home = {
      packages = [
        pkgs.yaru-theme
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
      };

      lightModeScripts = {
        gtk-theme = applyGtkTheme theme.gtk.light;
      };
    };
  }
