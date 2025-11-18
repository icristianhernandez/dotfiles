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
    "./nixos#apps.${pkgs.stdenv.hostPlatform.system}.nixos-lint"
    "--"
  ];
  meta = {
    description = "Run nixos-lint in this flake";
  };
}
