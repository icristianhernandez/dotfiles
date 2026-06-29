{
  pkgs,
  guardRole,
  hasRole,
  ...
}:

guardRole "desktop" {
  environment.systemPackages =
    with pkgs;
    let
      chrome =
        if hasRole "thinkpadE14" then
          google-chrome.override {
            commandLineArgs = "--ignore-gpu-blocklist --disable-vulkan --enable-features=VaapiVideoDecode --disable-features=UseChromeOSDirectVideoDecoder --use-angle=gl --disable-gpu-program-cache --password-store=gnome-libsecret";
          }
        else
          google-chrome;
    in
    [
      chrome
      librewolf
      discord
      vesktop
      telegram-desktop
      pinta

      ## libreoffice and spellchecker with hunspell
      # libreoffice
      # hunspell
      # hunspellDicts.es_VE
      # hunspellDicts.en_US
      ## font fix: https://wiki.nixos.org/wiki/ONLYOFFICE
      onlyoffice-desktopeditors

      wl-clipboard
      xclip
    ];

  fonts.packages = with pkgs; [
    inter
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    noto-fonts-emoji-blob-bin
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
  ];

  boot.kernelPackages = pkgs.linuxPackages;

  hardware.enableAllFirmware = true;
  programs = {
    dconf.enable = true;
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend-then-hibernate";
      };
    };
  };

  systemd.sleep.settings.Sleep.HibernateDelaySec = "5min";

  boot = {
    loader.systemd-boot.enable = true;
    initrd.systemd.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services = {
    dbus.enable = true;
    accounts-daemon.enable = true;
    resolved.enable = true;

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
