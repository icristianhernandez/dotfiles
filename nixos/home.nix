{ config, pkgs, plasma-manager, ... }:

{
  imports = [ plasma-manager.homeModules.plasma-manager ];

  home.username = "cristianh";
  home.homeDirectory = "/home/cristianh";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
  ];

  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
       AddKeysToAgent yes
    '';
  };

  home.sessionVariables = {
    SSH_ASKPASS = "/run/current-system/sw/bin/ksshaskpass";
    SSH_ASKPASS_REQUIRE = "prefer";
    EDITOR = "nvim +Man!";
  };


  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/cristianh/dotfiles/nvim/.config/nvim/";
    recursive = true;
  };

  programs.bash = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "cristian";
    userEmail = "cristianhernandez9007@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.yazi.enable = true;

  programs.plasma = {
    enable = true;
    # overrideConfig = true;

    kwin.effects.shakeCursor.enable = false;

    configFile = {
      "kwinrc"."Xwayland"."Scale" = 1.5;
      "kdeglobals"."KDE"."AnimationDurationFactor" = 0;
      "kdeglobals"."General"."UseSystemBell" = true;
      "plasmaparc"."General"."VolumeStep" = 3;
      "kwinrc"."Wayland"."EnablePrimarySelection" = false;
    };

    input = {
      keyboard = {
        repeatDelay = 150;
        repeatRate = 20.0;
      };

      mice = [
        {
          enable = true;
          name = "Logitech G305";
          accelerationProfile = "none";
          acceleration = 0;
          productId = "4074";
          vendorId = "046d";
        }
      ];
    };

    powerdevil = {
      batteryLevels.lowLevel = 25;

      AC = {
        powerProfile = "balanced";
      };

      battery = {
        powerProfile = "powerSaving";
        whenSleepingEnter = "standbyThenHibernate";

      };

      lowBattery = {
        displayBrightness = 8;
        powerProfile = "powerSaving";
      };
    };
  };
}
