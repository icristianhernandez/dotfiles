{ config, pkgs, ... }:

let
  # Import global settings from our centralized config file.
  globals = import ../config/globals.nix;
in
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Set keyboard layout to Spanish and disable mouse acceleration.
  services.xserver.layout = "es";
  services.xserver.libinput.mouse.accelProfile = "flat";

  # Enable the SDDM Display Manager.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.theme = globals.sddmTheme;


  # Enable the KDE Plasma 6 Desktop Environment.
  services.xserver.desktopManager.plasma6.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following line.
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
