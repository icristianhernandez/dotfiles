{
  config,
  guardRole,
  pkgs,
  lib,
  ...
}:

let
  port = "8080";
in
guardRole "desktop" {
  home = {
    file = {
      ".local/share/Tachidesk/server.conf".text = ''
        server {
          port = ${port}
          extensionRepos = [
            "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
          ]
          backupPath = "${config.home.homeDirectory}/dotfiles/backups/suwayomi"
          backupInterval = 1
          backupTime = "03:00"
          backupTTL = 90
        }
      '';

      ".local/share/vicinae/scripts/suwayomi-toggle" = {
        text = ''
          #!/usr/bin/env bash
          # @vicinae.schemaVersion 1
          # @vicinae.title Toggle Suwayomi
          # @vicinae.mode silent
          # @vicinae.icon bookmark
          # @vicinae.keywords ["manga", "reader", "suwayomi", "tachidesk"]

          export PATH="${
            lib.makeBinPath [
              pkgs.curl
              pkgs.libnotify
              pkgs.xdg-utils
            ]
          }:$PATH"

          SERVICE="suwayomi-server"

          if systemctl --user is-active --quiet "$SERVICE" 2>/dev/null; then
            systemctl --user stop "$SERVICE"
            notify-send "Suwayomi" "Server stopped"
          else
            systemctl --user start "$SERVICE"
            for i in $(seq 1 15); do
              if curl -sf http://localhost:${port}/ >/dev/null 2>&1; then
                xdg-open http://localhost:${port}/
                notify-send "Suwayomi" "Server ready on :${port}"
                exit 0
              fi
              sleep 0.5
            done
            notify-send -u critical "Suwayomi" "Failed to start (timeout)"
            exit 1
          fi
        '';
        executable = true;
      };
    };
  };

  systemd.user.services.suwayomi-server = {
    Unit = {
      Description = "Suwayomi Manga Reader Server";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${lib.getExe pkgs.suwayomi-server}";
      Restart = "on-failure";
    };
    Install.WantedBy = [ ];
  };
}
