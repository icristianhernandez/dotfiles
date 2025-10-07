{
  pkgs,
  mkApp,
  ...
}:
mkApp {
  program = "${pkgs.nix}/bin/nix";
  argv = [
    "--extra-experimental-features"
    "nix-command flakes"
    "run"
    "./nixos#apps.${pkgs.system}.nixos-fmt"
    "--"
  ];
  meta = {
    description = "Run nixos-fmt in this flake";
  };
}
