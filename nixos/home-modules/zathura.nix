{
  pkgs,
  lib,
  guardRole,
  ...
}:

let
  darkProfile = ''
    set recolor true
    set recolor-keephue false
    set recolor-darkcolor "#cdd6f4"
    set recolor-lightcolor "#1e1e2e"
    set default-bg "#11111b"
    set default-fg "#cdd6f4"
    set statusbar-bg "#181825"
    set statusbar-fg "#cdd6f4"
    set inputbar-bg "#181825"
    set inputbar-fg "#cdd6f4"
    set completion-bg "#313244"
    set completion-fg "#cdd6f4"
    set completion-group-bg "#1e1e2e"
    set completion-group-fg "#a6adc8"
    set completion-highlight-bg "#89b4fa"
    set completion-highlight-fg "#1e1e2e"
    set notification-bg "#313244"
    set notification-fg "#cdd6f4"
    set notification-error-bg "#f38ba8"
    set notification-error-fg "#1e1e2e"
    set notification-warning-bg "#f9e2af"
    set notification-warning-fg "#1e1e2e"
    set index-bg "#1e1e2e"
    set index-fg "#cdd6f4"
    set index-active-bg "#89b4fa"
    set index-active-fg "#1e1e2e"
    set highlight-color "rgba(137,180,250,0.5)"
    set highlight-active-color "rgba(166,227,161,0.5)"
    set highlight-fg "rgba(30,30,46,0.5)"
    set render-loading-bg "#1e1e2e"
    set render-loading-fg "#cdd6f4"
  '';

  lightProfile = ''
    set recolor false
    set recolor-keephue false
    set recolor-darkcolor "#000000"
    set recolor-lightcolor "#FFFFFF"
    set default-bg "#dce0e8"
    set default-fg "#4c4f69"
    set statusbar-bg "#e6e9ef"
    set statusbar-fg "#4c4f69"
    set inputbar-bg "#e6e9ef"
    set inputbar-fg "#4c4f69"
    set completion-bg "#ccd0da"
    set completion-fg "#4c4f69"
    set completion-group-bg "#eff1f5"
    set completion-group-fg "#6c6f85"
    set completion-highlight-bg "#1e66f5"
    set completion-highlight-fg "#eff1f5"
    set notification-bg "#ccd0da"
    set notification-fg "#4c4f69"
    set notification-error-bg "#d20f39"
    set notification-error-fg "#eff1f5"
    set notification-warning-bg "#df8e1d"
    set notification-warning-fg "#eff1f5"
    set index-bg "#eff1f5"
    set index-fg "#4c4f69"
    set index-active-bg "#1e66f5"
    set index-active-fg "#eff1f5"
    set highlight-color "rgba(30,102,245,0.5)"
    set highlight-active-color "rgba(64,160,43,0.5)"
    set highlight-fg "rgba(239,241,245,0.5)"
    set render-loading-bg "#eff1f5"
    set render-loading-fg "#4c4f69"
  '';

  applyZathuraTheme = profile: ''
    config_dir="$HOME/.config/zathura"
    mkdir -p "$config_dir"
    cat > "$config_dir/mode.auto.conf" <<'EOF'
    ${profile}
    EOF

    ${pkgs.dbus}/bin/dbus-send --session --dest=org.freedesktop.DBus \
      --type=method_call --print-reply /org/freedesktop/DBus \
      org.freedesktop.DBus.ListNames 2>/dev/null \
      | ${pkgs.gnugrep}/bin/grep -o 'org\.pwmt\.zathura\.PID-[0-9]\+' \
      | while read -r name; do
          ${pkgs.dbus}/bin/dbus-send --session --dest="$name" \
            --type=method_call --print-reply /org/pwmt/zathura \
            org.pwmt.zathura.SourceConfig 2>/dev/null
        done || true
  '';
in
guardRole "desktop" {
  programs.zathura = {
    enable = true;

    extraConfig = ''
      set selection-clipboard clipboard
      set page-v-padding 2

      # Default dark profile (overridden by mode.auto.conf when present)
      ${darkProfile}

      include mode.auto.conf
    '';
  };

  home.activation.createZathuraModeConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mode_file="$HOME/.config/zathura/mode.auto.conf"
    if [ ! -e "$mode_file" ]; then
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$(dirname "$mode_file")"
      $DRY_RUN_CMD cat > "$mode_file" <<'EOF'
    ${darkProfile}
    EOF
    fi
  '';

  home.activation.setZathuraAsDefaultPdfViewer = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.xdg-utils}/bin/xdg-mime default org.pwmt.zathura.desktop application/pdf
  '';

  services.darkman = {
    darkModeScripts = {
      zathura = applyZathuraTheme darkProfile;
    };

    lightModeScripts = {
      zathura = applyZathuraTheme lightProfile;
    };
  };
}
