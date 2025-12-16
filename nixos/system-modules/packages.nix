{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # OS Base
    ntfs3g
    openssh

    # CLI Utils
    unrar
    wget
    curl
    ripgrep
    fd
    gnutar
    unzip
    cargo
    gnumake

    # Languages
    nodejs_24
    gcc
    (python313.withPackages (ps: [ ps.pip ]))
    go
    mermaid-cli

    # Dev Environment
    lazygit
  ];
}
