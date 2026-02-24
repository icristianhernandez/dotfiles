{
  guardRole,
  lib,
  pkgs,
  ...
}:

guardRole "plasma" {
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-mauve";
    };
    desktopManager.plasma6.enable = true;
  };

  security.pam.services.sddm.kwallet.enable = true;

  programs.ssh.startAgent = lib.mkForce true;

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  networking.firewall = {
    allowedTCPPorts = [
      53
      80
      443
    ];
    allowedUDPPorts = [
      53
      67
      68
    ];
  };

  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.ffmpegthumbs
    kdePackages.ark
    p7zip
    (catppuccin-sddm.override {
      flavor = "mocha";
      accent = "mauve";
    })
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    kate
    elisa
  ];
}
