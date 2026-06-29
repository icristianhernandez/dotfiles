{
  pkgs,
  lib,
  guardRole,
  ...
}:

guardRole "desktop" {
  services.gnome.gnome-keyring.enable = true;
  programs = {
    dconf.enable = true;
    ssh.startAgent = false;
    ssh.askPassword = lib.mkForce "${pkgs.gcr}/libexec/seahorse/ssh-askpass";
    seahorse.enable = true;
  };

  xdg.portal.extraPortals = [ pkgs.gnome-shell ];

  security.pam.services = {
    login.enableGnomeKeyring = true;
    gdm-password.enableGnomeKeyring = true;
    gdm-autologin.enableGnomeKeyring = true;
    greetd.enableGnomeKeyring = true;
  };

  environment.systemPackages = with pkgs; [
    libsecret
  ];
}
