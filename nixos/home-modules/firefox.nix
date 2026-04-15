{
  pkgs,
  guardRole,
  ...
}:

guardRole "desktop" {
  home.packages = with pkgs; [
    firefox-gnome-theme
  ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      userChrome = "${pkgs.firefox-gnome-theme}/userChrome.css";
      userContent = "${pkgs.firefox-gnome-theme}/userContent.css";
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "svg.context-properties.content.enabled" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "extensions.webextensions.ExtensionStorageIDB.enabled" = false;
      };
    };
  };
}
