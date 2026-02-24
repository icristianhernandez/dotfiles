{
  pkgs,
  guardRole,
  ...
}:

guardRole "gaming" {
  environment.systemPackages = with pkgs.unstable; [
    wineWow64Packages.unstableFull
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
    wineWow64Packages.fonts
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
      extraPkgs =
        pkgsArg: with pkgsArg; [
          # If crash/bugs happen with gamescope, adding/removing the next
          # dependencies can be the fix
          libkrb5
          keyutils
          libgdiplus

          libxcursor
          libxi
          libxinerama
          libxscrnsaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
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
