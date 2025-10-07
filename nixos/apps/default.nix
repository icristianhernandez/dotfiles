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
    mkApp = import ../lib/mk-app.nix { };
    call =
      file:
      import file {
        inherit pkgs mkApp;
        _lib = lib;
      };

    fmtApp = call ./fmt.nix;
    lintApp = call ./lint.nix;
    ciApp = call ./ci.nix;

    nixosFmt = call ./nixos-fmt.nix;
    nixosLint = call ./nixos-lint.nix;
    nixosCi = call ./nixos-ci.nix;

    nvimFmt = call ./nvim-fmt.nix;
    nvimCi = call ./nvim-ci.nix;

    workflowsLint = call ./workflows-lint.nix;
    workflowsCi = call ./workflows-ci.nix;
  in
  {
    fmt = fmtApp;
    lint = lintApp;

    "nixos-fmt" = nixosFmt;
    "nixos-lint" = nixosLint;
    "nixos-ci" = nixosCi;

    "nvim-fmt" = nvimFmt;
    "nvim-ci" = nvimCi;

    "workflows-lint" = workflowsLint;
    "workflows-ci" = workflowsCi;

    ci = ciApp;
  }
)
