{
  pkgs,
  guardRole,
  ...
}:

guardRole "gaming" {
  environment.systemPackages = with pkgs.unstable; [
    wineWowPackages.stagingFull
    winePackages.fonts
    winetricks
    # things needed for winetricks
    cabextract

    (heroic.override {
      extraPkgs = pkgsArg: [
        pkgsArg.libgdiplus
      ];
    })

    tower-pixel-dungeon
    shattered-pixel-dungeon
    crawlTiles
    mindustry-wayland

  ];

  fonts.packages = with pkgs.unstable; [
    wineWowPackages.fonts
  ];

  programs.gamescope = {
    enable = true;
    package = pkgs.unstable.gamescope;
    # args = [
    #   "--width 1280"
    #   "--height 720"
    #   # "--scaling stretch"
    #   "--fullscreen"
    # ];
    # the next crashes launch games with gamescope in other compositors
    # capSysNice = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    extraCompatPackages = with pkgs.unstable; [ proton-ge-bin ];

    package = pkgs.unstable.steam.override {
      extraPkgs = pkgsArg: [
        # If crash/bugs happen with gamescope, adding/removing the next
        # dependencies can be the fix
        pkgsArg.libkrb5
        pkgsArg.keyutils
        pkgsArg.libgdiplus

        pkgsArg.xorg.libXcursor
        pkgsArg.xorg.libXi
        pkgsArg.xorg.libXinerama
        pkgsArg.xorg.libXScrnSaver
        pkgsArg.libpng
        pkgsArg.libpulseaudio
        pkgsArg.libvorbis
        pkgsArg.stdenv.cc.cc.lib
      ];

      extraEnv = {
        # PIPEWIRE_NODE = "Game";
        # PULSE_SINK = "Game";
        STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
        # PROTON_ENABLE_WAYLAND = "1"; # If games crash, delete this line
        # PROTON_USE_WOW64 = "1";
        # SDL_VIDEODRIVER = "wayland";
      };

      extraProfile = ''
        unset TZ
      '';

      privateTmp = false;
    };
  };
}
