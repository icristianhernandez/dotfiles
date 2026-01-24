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
    unstable.vscode.fhs
    unstable.github-copilot-cli
  ];

  # programs.vscode = {
  #   enable = true;
  #   package = pkgs.vscode.fhs;
  # };
}
