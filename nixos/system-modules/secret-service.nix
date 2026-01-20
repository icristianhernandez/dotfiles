{
  pkgs,
  guardRole,
  ...
}:

guardRole "desktop" {
  services.gnome.gnome-keyring.enable = true;
  programs.ssh.startAgent = false;

  security.pam.services = {
    login.enableGnomeKeyring = true; # For TTY logins (Niri/Sway)
    sddm.enableGnomeKeyring = true; # For Plasma (if using SDDM)
    gdm.enableGnomeKeyring = true; # For GNOME
    greetd.enableGnomeKeyring = true; # For Greetd users
  };

  # GUI for secrets (I don't need that too much, really)
  programs.seahorse.enable = true;

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
