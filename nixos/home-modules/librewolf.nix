{
  # pkgs,
  guardRole,
  ...
}:

guardRole "desktop" {
  programs.librewolf = {
    enable = true;
    profiles.default = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "svg.context-properties.content.enabled" = true;
        "toolkit.tabbox.switchByScrolling" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "extensions.webextensions.ExtensionStorageIDB.enabled" = false;
        "mousewheel.default.delta_multiplier_y" = 275;
        "browser.tabs.tabMinWidth" = 0;
        "browser.tabs.closeWindowWithLastTab" = false;
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "browser.backspace_action" = 0;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "widget.wayland.vsync.enabled" = true;
        "gfx.webrender.compositor" = true;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "extensions.pocket.enabled" = false;
        "signon.rememberSignons" = false;
        "privacy.clearOnShutdown.cookies" = true;
      };
    };
  };
}
