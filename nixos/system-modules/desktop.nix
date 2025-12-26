{
  pkgs,
  guardRole,
  ...
}:

guardRole "desktop" {
  environment.systemPackages = with pkgs; [
    google-chrome
    nerd-fonts.jetbrains-mono
    wl-clipboard
    xclip
  ];

  # my storage partition
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "ntfs" ];
    kernelParams = [ "mem_sleep_default=deep" ];
  };
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/EC68C95668C92066";
    fsType = "ntfs3";
    options = [
      "nofail"
      "rw"
      "uid=1000"
    ];
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
