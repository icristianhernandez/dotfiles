{
  guardRole,
  pkgs,
  ...
}:

guardRole "plasma" {
  services = {
    displayManager.plasma-login-manager = {
      enable = true;
    };
    desktopManager.plasma6.enable = true;
  };

  qt = {
    enable = true;
    style = "kvantum";
  };

  # SSH keys are handled by gnome-keyring-ssh (see secret-service.nix); standalone ssh-agent stays off.
  environment.systemPackages = with pkgs; [
    kdePackages.aurorae
    kdePackages.dolphin
    kdePackages.ffmpegthumbs
    kdePackages.ark
    p7zip
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    kate
    elisa
  ];
}
