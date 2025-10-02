{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

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
    }:
    let
      const = import ./lib/const.nix;
      systems = [ "x86_64-linux" ];
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
      formatter = import ./lib/formatter.nix { inherit nixpkgs systems; };

      checks = import ./lib/checks.nix {
        inherit nixpkgs systems;
        root = ./.;
      };

    };
}
