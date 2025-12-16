1. Objectives, Scope, and Success Criteria

- Deliver a simple Roles/Profiles layout for multi-host NixOS + Home Manager without adding new abstractions. Hosts pick roles; roles gate modules.
- Keep current module contents intact; only wire them through roles.
- Success: A host is defined by listing its roles in `flake.nix`, and modules enable themselves via `mkIf (elem role roles)`.

2. Current Configuration Audit

- `nixos/flake.nix` builds a single host `nixos` with WSL + Home Manager; modules are auto-imported via `lib/import-modules.nix`.
- Constants (`lib/const.nix`) hold user/timezone/state versions; passed through `specialArgs` and `home-manager.extraSpecialArgs`.
- System modules (`system-modules/*`): core settings, locale, packages, shell, users, and WSL. All always-on today.
- Home modules (`home-modules/*`): base home config plus fish, git, nvim, opencode, ssh-agent/keychain, starship, yazi. Also always-on.
- `import-modules.nix` simply imports every `.nix` file; no role-based filtering yet.

3. Action Checklist

- Define per-host roles in `flake.nix` (e.g., `rolesFor = { wsl = [ "base" "wsl" "cli" "hm-dev" ]; };`) and pass `roles` via `specialArgs`/`extraSpecialArgs`.
- Add a small helper attrset (or reuse `const`) to expose `roles` to modules and home modules.
- Gate each system module with `lib.mkIf (elem "<role>" roles)` using plain lists (no new abstractions).
- Gate each home module similarly for Home Manager roles.
- (Optional) Add tiny `hosts/<name>.nix` files for hostName and host-specific tweaks while keeping roles the primary switch.

4. Execution Strategy & Implementation (Grounding Snippets)

- Inject roles from `flake.nix`:

  ```nix
  let
    systems = [ "x86_64-linux" ];
    rolesFor = {
      wsl = [ "base" "wsl" "cli" "hm-dev" ];
      laptop = [ "base" "cli" "hm-dev" ];
    };
  in {
    nixosConfigurations =
      builtins.mapAttrs
        (host: roles:
          nixpkgs.lib.nixosSystem {
            system = builtins.head systems;
            specialArgs = { inherit const roles; };
            modules = [
              { networking.hostName = host; }
              { config.roles = roles; } # single source of truth
              (import ./lib/import-modules.nix { inherit (nixpkgs) lib; dir = ./system-modules; })
            ];
          })
        rolesFor;
  }
  ```

- Example system module guard:

  ```nix
  # system-modules/wsl.nix
  { lib, roles ? [ ], const, ... }: {
    config = lib.mkIf (lib.elem "wsl" roles) {
      wsl.enable = true;
      wsl.defaultUser = const.user;
      wsl.useWindowsDriver = true;
    };
  }
  ```

- Example Home Manager guard:

  ```nix
  # home-modules/nvim.nix
  { lib, roles ? [ ], const, pkgs, ... }: {
    config = lib.mkIf (lib.elem "hm-dev" roles) {
      xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/nvim";
      programs.neovim.enable = true;
      programs.neovim.extraPackages = with pkgs; [ ripgrep fd tree-sitter nixd ];
    };
  }
  ```

- Minimal host files if needed:

  ```nix
  # hosts/wsl.nix
  { ... }: { networking.hostName = "wsl"; }
  ```
