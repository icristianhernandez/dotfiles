{
  pkgs,
  guardRole,
  ...
}:

guardRole "gaming" {
  environment.systemPackages = with pkgs; [
    lutris
    wineWowPackages.stable
    winetricks

    (heroic.override {
      extraPkgs =
        pkgs: with pkgs; [
          libgdiplus
        ];
    })

    tower-pixel-dungeon
    shattered-pixel-dungeon
    crawlTiles
    mindustry-wayland
  ];

  programs.gamescope = {
    enable = true;
    # the next crashes launch games with gamescope in other compositors
    # capSysNice = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    extraCompatPackages = with pkgs; [ proton-ge-bin ];

    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          libkrb5
          keyutils
          libgdiplus
        ];

      extraEnv = {
        # PIPEWIRE_NODE = "Game";
        # PULSE_SINK = "Game";
        # STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
        # PROTON_ENABLE_WAYLAND = true; # If games crash, delete this line
        PROTON_USE_WOW64 = true;
      };

      extraProfile = ''
        unset TZ
      '';

      privateTmp = false;
    };
  };
}
