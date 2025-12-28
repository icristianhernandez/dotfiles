{
  pkgs,
  guardRole,
  ...
}:

guardRole "gaming" {
  environment.systemPackages = with pkgs; [
    lutris
    tower-pixel-dungeon
    shattered-pixel-dungeon
    crawlTiles
    mindustry-wayland
  ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
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
          ## for gamescopeSession compatibility
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
    };
  };
}
