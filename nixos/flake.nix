{
  description = "Personal NixOS configuration with Roles & Profiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-wsl,
      home-manager,
      ...
    }:
    let
      systems = [ "x86_64-linux" ];
      eachSystem =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );

      # Host builder with roles support
      mkHost = import ./lib/mkHost.nix {
        inherit nixpkgs nixos-wsl home-manager;
      };
    in
    {
      nixosConfigurations = {
        # Primary WSL development machine
        nixos = mkHost {
          hostname = "nixos";
          system = "x86_64-linux";
          roles = [ "base" "wsl" "development" ];
        };

        # Example: Future server host (commented out)
        # server = mkHost {
        #   hostname = "server";
        #   system = "x86_64-linux";
        #   roles = [ "base" "server" ];
        # };
      };

      formatter = eachSystem ({ pkgs, ... }: pkgs.nixfmt);
      apps = import ./apps { inherit nixpkgs systems; };
    };
}
