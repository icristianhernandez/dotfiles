{
  pkgs,
  guardRole,
  ...
}:

guardRole "desktop" {
  environment.systemPackages = with pkgs; [
    google-chrome
    discord
    nerd-fonts.jetbrains-mono
    wl-clipboard
    xclip
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  hardware.enableAllFirmware = true;
  programs.dconf.enable = true;

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend-then-hibernate";
      };
    };
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=5min
  '';

  # my storage partition
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 25;
    priority = 100;
  };

  services = {
    dbus.enable = true;
    accounts-daemon.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    xserver = {
      enable = true;

      xkb = {
        layout = "latam";
        variant = "";
      };
    };

    printing.enable = true;
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  networking.networkmanager.enable = true;
}
