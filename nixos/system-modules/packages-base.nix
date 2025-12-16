{ pkgs, guardRole, ... }:

guardRole "base" {
  environment.systemPackages = with pkgs; [
    # OS Base
    ntfs3g
    openssh

    # CLI Utils
    wget
    curl
    ripgrep
    fd
    gnutar
    unzip
    unrar
  ];
}
