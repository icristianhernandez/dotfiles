{
  pkgs,
  guardRole,
  hasRole,
  ...
}:

guardRole "desktop" {
  services.gnome.gnome-keyring.enable = !hasRole "plasma";
  programs.ssh.startAgent = false;

  security.pam.services = {
    login.enableGnomeKeyring = true; # For TTY logins (Niri/Sway)
    sddm.enableGnomeKeyring = !hasRole "plasma"; # Only for GNOME (Plasma uses KWallet)
    gdm.enableGnomeKeyring = true; # For GNOME
    greetd.enableGnomeKeyring = true; # For Greetd users
  };

  # GUI for secrets - disable on Plasma (uses KDE tools instead)
  programs.seahorse.enable = !hasRole "plasma";

  environment.systemPackages = with pkgs; [
    # For terminal (ssh, mostly)
    libsecret
  ];

  services.dbus.packages = [ pkgs.gcr ];

  # that can be brittle, so can be removed in future for debugging purposes
  environment.sessionVariables = {
    # Forces all OpenSSL-linked apps to use the NixOS system bundle
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    SSL_CERT_DIR = "/etc/ssl/certs";

    # Specifically for Node.js-based CLIs (like Copilot)
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
  };
}
