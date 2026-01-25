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
      extraPkgs =
        pkgs: with pkgs.unstable; [
          libgdiplus
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
    args = [
      "--width 1280"
      "--height 720"
      "--scaling stretch"
      "--fullscreen"
    ];
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
        pkgs: with pkgs.unstable; [
          libkrb5
          keyutils
          libgdiplus
        ];

      # extraEnv = {
      #   # PIPEWIRE_NODE = "Game";
      #   # PULSE_SINK = "Game";
      #   # STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
      #   # PROTON_ENABLE_WAYLAND = true; # If games crash, delete this line
      #   # PROTON_USE_WOW64 = true;
      # };

      extraProfile = ''
        unset TZ
      '';

      privateTmp = false;
    };
  };
}
