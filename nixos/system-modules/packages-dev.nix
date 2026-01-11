{ pkgs, guardRole, ... }:
guardRole "dev" {
  environment.systemPackages = with pkgs; [
    # CLI Utils
    cargo
    gnumake

    # Languages
    nodejs_24
    gcc
    (python313.withPackages (ps: [ ps.pip ]))
    go
    mermaid-cli
    postgresql

    # Dev Environment
    lazygit
  ];
}
