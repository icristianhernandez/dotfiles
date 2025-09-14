{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Caracas";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_VE.UTF-8";
    LC_IDENTIFICATION = "es_VE.UTF-8";
    LC_MEASUREMENT = "es_VE.UTF-8";
    LC_MONETARY = "es_VE.UTF-8";
    LC_NAME = "es_VE.UTF-8";
    LC_NUMERIC = "es_VE.UTF-8";
    LC_PAPER = "es_VE.UTF-8";
    LC_TELEPHONE = "es_VE.UTF-8";
    LC_TIME = "es_VE.UTF-8";
  };

  services.xserver.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = pkgs.steam-run.args.multiPkgs pkgs;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };
  console.keyMap = "la-latin1";

  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cristianh = {
    isNormalUser = true;
    description = "cristian hernandez";
    extraGroups = [
      "networkmanager"
      "wheel"
      "games"
    ];
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    google-chrome
    wget
    curl
    kitty
    alacritty
    wezterm
    ghostty
    nodePackages_latest.nodejs
    gcc
    python313
    python313Packages.pip
    ripgrep
    fd
    gnutar
    unzip
    temurin-bin
    ntfs3g
    kdePackages.ksshaskpass

    unstable.neovim
    unstable.neovide
    unstable.opencode
    steam
  ];

  # Graphics settings (enable, hardware acceleration, quick sync video)
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # For modern Intel CPU's
      intel-media-driver # Enable Hardware Acceleration
      vpl-gpu-rt # Enable QSV
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # Enable Steam module for FHS and compatibility
  programs.steam.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-generations +3";
  };

  fileSystems."/media/storage" = {
    device = "/dev/disk/by-uuid/01D9F19C3789CBF0";
    fsType = "ntfs-3g";
    options = [
      "uid=1000" # cristianh's UID
      "gid=100" # users group GID
      "dmask=027" # Directories: rwxr-x---
      "fmask=137" # Files: rw-r-----
      "windows_names"
      "locale=en_US.UTF-8"
    ];
  };
}
