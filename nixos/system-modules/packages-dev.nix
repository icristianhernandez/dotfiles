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
    statix
    unstable.vscode.fhs
    # unstable.github-copilot-cli
    # unstable.pi-coding-agent
  ];

  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscode.fhs;
  # };
}
