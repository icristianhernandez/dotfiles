{
  const,
  guardRole,
  hasRole,
  pkgs,
  lib,
  input,
  ...
}:

let
  filesProviderPaths = lib.concatStringsSep ";" (
    [ const.homeDir ] ++ lib.optionals (hasRole "thinkpadE14") [ "/mnt/storage" ]
  );
in
guardRole "desktop" {
  disabledModules = [ "programs/vicinae.nix" ];
  imports = [
    "${input.home-manager-unstable}/modules/programs/vicinae"
  ];

  warnings = lib.optional (lib.versionAtLeast pkgs.vicinae.version "0.17.0") "Vicinae in stable nixpkgs reached version ${pkgs.vicinae.version}. Consider switching back from unstable.vicinae in vicinae.nix (unstable overlay and home manager fix).";

  xdg.configFile."vicinae/base_config.json".text = builtins.toJSON {
    close_on_focus_loss = false;
    pop_to_root_on_close = true;
    pop_on_backspace = false;
    activate_on_single_click = true;
    providers = {
      applications.preferences.defaultAction = "launch";
      clipboard.enabled = false;
      files = {
        preferences.paths = filesProviderPaths;
        entrypoints.search.alias = "/";
      };
      shortcuts.entrypoints."8bed762c-71a7-4f82-abd8-43e16af81792".alias = "*";
    };
  };

  home.activation.vicinaeEnsureSettingsImport = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        settings_path="$HOME/.config/vicinae/settings.json"

        if [ ! -e "$settings_path" ]; then
          $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$HOME/.config/vicinae"
          $DRY_RUN_CMD cat > "$settings_path" <<'EOF'
    {
      "imports": ["base_config.json"]
    }
    EOF
        fi
  '';

  programs.vicinae = {
    enable = true;
    # unstable to have vicinae v 0.20.x, if stable reach or pass that, change it
    package = pkgs.unstable.vicinae;
    systemd = {
      enable = true;
      autoStart = true;
      target = "graphical-session.target";
    };
  };
}
