{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    treefmt-nix.url = "github:numtide/treefmt-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      ...
    }@inputs:
    let
      const = import ./lib/const.nix;
      systems = [ "x86_64-linux" ];
      for_each_system = nixpkgs.lib.genAttrs systems;
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit const; };

          modules = [
            ./configuration.nix
            nixos-wsl.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit const; };
                users = {
                  "${const.user}" = ./home.nix;
                };
              };
            }
          ];
        };
      };

      formatter = for_each_system (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        treefmtEval.config.build.wrapper
      );

      checks = for_each_system (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          statix = pkgs.runCommand "statix-check" { buildInputs = [ pkgs.statix ]; } ''
            set -eu
            # Advisory: report findings but do not fail the check
            statix check ${./.} || true
            touch "$out"
          '';

          deadnix = pkgs.runCommand "deadnix-check" { buildInputs = [ pkgs.deadnix ]; } ''
            set -eu
            # Advisory: report findings but do not fail the check
            deadnix ${./.}
            touch "$out"
          '';

          formatting = treefmtEval.config.build.check self;
        }
      );

    };
}
