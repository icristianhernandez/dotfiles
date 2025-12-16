# NixOS Multihost Roles/Profiles Refactor Plan

## 1. Objectives, Scope, and Success Criteria

### Objectives

1. Enable multihost support in the NixOS flake configuration
2. Implement a simple "Roles & Profiles" pattern for module enablement
3. Allow hosts to declare their capabilities via roles in `flake.nix`
4. Keep the implementation minimal using standard NixOS patterns (`lib.mkIf`)

### Scope

- Add roles mechanism via `specialArgs`
- Create role definitions and role-checking utilities
- Categorize existing modules by roles
- **Do NOT** modify existing module implementations (only add role guards)
- **Do NOT** change directory structure (already flat and simple)

### Success Criteria

> "A host can be defined by simply listing its roles in `flake.nix`."

A new host can be added with minimal boilerplate:

```nix
nixosConfigurations.new-host = mkHost {
  hostname = "new-host";
  system = "x86_64-linux";
  roles = [ "base" "development" "wsl" ];
};
```

---

## 2. Current Configuration Audit

### Repository Structure

```
nixos/
├── flake.nix                 # Single host "nixos", WSL-based
├── lib/
│   ├── const.nix             # User/system constants
│   ├── import-modules.nix    # Auto-import .nix files from directories
│   └── mk-app.nix            # App wrapper utility
├── system-modules/           # NixOS system-level modules
│   ├── core.nix              # Nix settings, nix-ld, GC
│   ├── locale.nix            # i18n/locale settings
│   ├── packages.nix          # System packages
│   ├── shell.nix             # Fish/Bash/Starship setup
│   ├── users.nix             # User account definition
│   └── wsl.nix               # WSL-specific settings
└── home-modules/             # Home Manager modules
    ├── fish.nix              # Fish shell config
    ├── git.nix               # Git configuration
    ├── home-config.nix       # Home Manager base config
    ├── nvim.nix              # Neovim setup
    ├── opencode.nix          # OpenCode tool
    ├── ssh-agent.nix         # SSH/keychain setup
    ├── starship.nix          # Starship prompt
    └── yazi.nix              # Yazi file manager
```

### Current Patterns

**Strengths:**
- Flat module structure (no deep nesting) ✓
- Constants centralized in `const.nix` ✓
- Auto-import mechanism avoids manual import lists ✓
- Clean separation between system and home modules ✓

**Gaps:**
- Single host only (`nixosConfigurations.nixos`)
- No role-based conditional module loading
- WSL module always enabled (no conditional logic)
- All modules load unconditionally

### Module Role Classification

| Module | Proposed Role(s) |
|--------|------------------|
| **System Modules** | |
| `core.nix` | `base` (always enabled) |
| `locale.nix` | `base` |
| `packages.nix` | `base` |
| `shell.nix` | `base` |
| `users.nix` | `base` |
| `wsl.nix` | `wsl` |
| **Home Modules** | |
| `home-config.nix` | `base` |
| `fish.nix` | `base` |
| `git.nix` | `development` |
| `nvim.nix` | `development` |
| `opencode.nix` | `development` |
| `ssh-agent.nix` | `development` |
| `starship.nix` | `base` |
| `yazi.nix` | `base` |

---

## 3. Action Checklist

### Phase 1: Role Infrastructure

- [ ] Create `lib/roles.nix` - role definitions and helper functions
- [ ] Update `lib/const.nix` - add host-specific overrides pattern

### Phase 2: Flake Refactor

- [ ] Create `lib/mkHost.nix` - host builder function
- [ ] Update `flake.nix` - use `mkHost` for host definitions
- [ ] Add example second host configuration (commented out)

### Phase 3: Module Role Guards

- [ ] Add role guards to `system-modules/wsl.nix`
- [ ] Add role guards to `home-modules/git.nix`
- [ ] Add role guards to `home-modules/nvim.nix`
- [ ] Add role guards to `home-modules/opencode.nix`
- [ ] Add role guards to `home-modules/ssh-agent.nix`

### Phase 4: Validation

- [ ] Test existing host still builds
- [ ] Document the roles pattern in README or comments

---

## 4. Execution Strategy & Implementation

### 4.1 Role Definitions (`lib/roles.nix`)

A minimal role system that defines available roles and provides a helper function.

```nix
# lib/roles.nix
{
  # Helper function: check if a role is active
  # Usage: lib.mkIf (hasRole "wsl") { ... }
  hasRole = roles: role: builtins.elem role roles;
}
```

### 4.2 Host Builder (`lib/mkHost.nix`)

A simple function to reduce boilerplate when defining hosts.

```nix
# lib/mkHost.nix
{
  nixpkgs,
  nixos-wsl,
  home-manager,
}:
{
  hostname,
  system,
  roles,
  extraModules ? [],
}:
let
  const = import ./const.nix;
  rolesLib = import ./roles.nix;
  
  # Check role at flake level (before specialArgs is available)
  hasRoleLocal = rolesLib.hasRole roles;
  
  # Partially applied hasRole for modules (via specialArgs)
  specialArgs = {
    inherit const;
    roles = roles;
    hasRole = hasRoleLocal;  # Modules use: hasRole "wsl"
  };
in
nixpkgs.lib.nixosSystem {
  inherit system specialArgs;
  
  modules = [
    # Core system modules (always imported, use mkIf internally)
    {
      networking.hostName = hostname;
      imports = import ./import-modules.nix {
        inherit (nixpkgs) lib;
        dir = ../system-modules;
      };
    }
    
    # WSL module (only if wsl role)
  ] ++ nixpkgs.lib.optionals (hasRoleLocal "wsl") [
    nixos-wsl.nixosModules.default
  ] ++ [
    # Home Manager
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        extraSpecialArgs = specialArgs;
        users.${const.user} = {
          imports = import ./import-modules.nix {
            inherit (nixpkgs) lib;
            dir = ../home-modules;
          };
        };
      };
    }
  ] ++ extraModules;
}
```

### 4.3 Updated `flake.nix`

The refactored flake with role-based host definitions.

```nix
# flake.nix
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

  outputs = { nixpkgs, nixos-wsl, home-manager, ... }:
  let
    systems = [ "x86_64-linux" ];
    eachSystem = f: nixpkgs.lib.genAttrs systems (system:
      f { inherit system; pkgs = nixpkgs.legacyPackages.${system}; }
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
```

### 4.4 Role-Guarded Module Example

How modules check for roles using standard `lib.mkIf`.

**System Module: `wsl.nix`**

```nix
# system-modules/wsl.nix
{ const, lib, hasRole, ... }:
{
  config = lib.mkIf (hasRole "wsl") {
    wsl = {
      enable = true;
      defaultUser = const.user;
      useWindowsDriver = true;
    };
  };
}
```

**Home Module: `nvim.nix`**

```nix
# home-modules/nvim.nix
{
  config,
  const,
  lib,
  pkgs,
  hasRole,
  ...
}:
{
  config = lib.mkIf (hasRole "development") {
    home.sessionVariables = {
      MANPAGER = "nvim +Man!";
      PAGER = "nvim";
      GIT_PAGER = "nvim";
    };

    xdg.configFile."nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${const.dotfilesDir}/nvim";
      recursive = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
      extraPackages = with pkgs; [
        ripgrep fd tree-sitter lsof nixfmt nixd
      ];
    };
  };
}
```

### 4.5 Base Modules (No Guard Needed)

Modules in the `base` role don't need guards since `base` is always included.
The following modules remain unchanged:

- `system-modules/core.nix`
- `system-modules/locale.nix`
- `system-modules/packages.nix`
- `system-modules/shell.nix`
- `system-modules/users.nix`
- `home-modules/home-config.nix`
- `home-modules/fish.nix`
- `home-modules/starship.nix`
- `home-modules/yazi.nix`

---

## Summary

This refactor introduces multihost support with a minimal "Roles & Profiles" pattern:

1. **`lib/roles.nix`** - Defines available roles and `hasRole` helper
2. **`lib/mkHost.nix`** - Reduces boilerplate for host definitions
3. **`flake.nix`** - Clean host definitions with role lists
4. **Modules** - Use `lib.mkIf (hasRole "role")` for conditional enabling

The pattern follows "Worse is Better" by:
- Using standard `lib.mkIf` instead of custom abstractions
- Keeping modules flat with inline role checks
- Avoiding complex option definitions or deep module hierarchies
- Passing `hasRole` via `specialArgs` for direct access

A new host requires only:
1. Add entry in `flake.nix` with `mkHost { hostname; system; roles; }`
2. No changes to modules needed (role guards already in place)
