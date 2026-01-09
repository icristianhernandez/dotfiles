{
  pkgs,
  guardRole,
  ...
}:

guardRole "desktop" {
  environment.systemPackages = with pkgs; [
    google-chrome
    discord
    telegram-desktop
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
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    noto-fonts-emoji-blob-bin
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    # source-han-sans
    # source-han-serif
    # source-han-mono
    # source-han-code-jp
    # ipafont
    # ipaexfont
    # unifont
    # symbola
    # stix-otf
    # stix-two
    # dejavu_fonts
    # libertinus
    # powerline-symbols
    # material-symbols
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
