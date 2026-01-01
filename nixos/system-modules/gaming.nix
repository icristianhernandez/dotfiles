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
    heroic

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

    # # I don't understand what the next thing does but can be useful
    # extest.enable = true;

    extraCompatPackages = [ pkgs.proton-ge-bin ];

    package = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          libkrb5
          keyutils
        ];
    };
  };
}
