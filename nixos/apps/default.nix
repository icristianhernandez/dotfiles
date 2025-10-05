{
  nixpkgs,
  systems,
}:
let
  for_each_system = nixpkgs.lib.genAttrs systems;
in
for_each_system (
  system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (pkgs) lib;
    mkApp = import ../lib/mk-app.nix { inherit lib; };

    # Legacy aggregate apps (kept for convenience)
    fmtApp = import ./fmt.nix { inherit pkgs lib mkApp; };
    lintApp = import ./lint.nix { inherit pkgs lib mkApp; };
    # Orchestrator will be redefined to call domain-specific apps
    ciApp = import ./ci.nix { inherit pkgs lib mkApp; };

    # Domain-specific apps
    nixosFmt = import ./nixos-fmt.nix { inherit pkgs lib mkApp; };
    nixosLint = import ./nixos-lint.nix { inherit pkgs lib mkApp; };
    nixosCi = import ./nixos-ci.nix { inherit pkgs lib mkApp; };

    nvimFmt = import ./nvim-fmt.nix { inherit pkgs lib mkApp; };
    nvimCi = import ./nvim-ci.nix { inherit pkgs lib mkApp; };

    workflowsLint = import ./workflows-lint.nix { inherit pkgs lib mkApp; };
    workflowsCi = import ./workflows-ci.nix { inherit pkgs lib mkApp; };
  in
  {
    # Legacy
    fmt = fmtApp;
    lint = lintApp;

    # New per-domain apps
    "nixos-fmt" = nixosFmt;
    "nixos-lint" = nixosLint;
    "nixos-ci" = nixosCi;

    "nvim-fmt" = nvimFmt;
    "nvim-ci" = nvimCi;

    "workflows-lint" = workflowsLint;
    "workflows-ci" = workflowsCi;

    # Orchestrator
    ci = ciApp;
  }
)
