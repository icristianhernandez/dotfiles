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
    postgresql

    # Dev Environment
    lazygit
    statix
    unstable.vscode.fhs
    unstable.neovide
  ];

  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscode.fhs;
  # };
}
