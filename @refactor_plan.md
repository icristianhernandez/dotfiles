# Roles & Profiles Refactor Plan (KISS)

## 1. Objectives, scope, success criteria

- Objective: Add simple multi-host support via a Roles/Profiles pattern while keeping the current "auto-import all modules" model and avoiding heavy abstractions. Keep WSL host behaviour identical.
- Scope: Add a per-host roles table in `nixos/flake.nix`, pass `roles` into modules (NixOS via `specialArgs`, HM via `home-manager.extraSpecialArgs`), and provide a unified `nixos/roles.nix` module that declares the `roles` option (strict whitelist) and exposes a helper factory `mkHelpers` (hasRole/mkIfRole/guardRole) for module gating.
- Success criteria: "A host can be defined by simply listing its roles in `nixos/flake.nix`." WSL (the current host) should behave the same after the refactor.

## 2. Current configuration audit (short)

- Entry point: `nixos/flake.nix` currently builds a single host at `nixosConfigurations.nixos` (see `nixos/flake.nix:38-68`). It auto-imports system modules (`nixos/lib/import-modules.nix:1-28`) and home modules similarly.
- Problematic unconditional imports: `nixos-wsl.nixosModules.default` is imported unconditionally and will break non-WSL hosts if left that way (`nixos/flake.nix:49`).
- Packages: `nixos/system-modules/packages.nix` mixes base and developer packages (nodejs, cargo, gcc, go, python, lazygit, etc.). Current content: `nixos/system-modules/packages.nix:1-30`.
- Home modules (nvim, git, opencode, fish, ssh-agent, starship, yazi) are always-on today (`nixos/home-modules/*`).
- `const` assumes a single username and is fine for now (`nixos/lib/const.nix:1-19`).

## 3. Action checklist

1. Add a simple host table in `nixos/flake.nix` (keep existing single host `nixos` for now). Pass `roles` and `hostName` as `specialArgs` and inject role helpers (`hasRole`, `mkIfRole`, `guardRole`).
2. Gate the WSL flake import: only include `nixos-wsl` when the host has role `wsl`.
3. Split packages into two modules under `nixos/system-modules/`:
   - `packages-base.nix` (minimal, always-applied)
   - `packages-dev.nix` (dev-only, guarded with `guardRole "dev"`)
4. Add guard-first role guards to existing modules where appropriate (use `guardRole "<role>" { ... }` at the top of modules):
   - `dev` → `nvim`, `git`, `opencode`, `packages-dev`.
   - `interactive` → `shell`, `fish`, `starship`, `ssh-agent`, `yazi`.
   - `wsl` → `wsl` (and also gate nixos-wsl at the flake level).
   - `base` → `core`, `locale`, `users` (these can also remain unconditional).
5. Add `nixos/roles.nix` as a single KISS module that declares the `roles` option (with a strict whitelist) and exposes `mkHelpers` (hasRole/mkIfRole/guardRole).
6. Update CI to continue building your existing host toplevel (`nixos`) and add tests for role validation and gating.
7. Validation: run `nix build ./nixos#nixosConfigurations.nixos.config.system.build.toplevel` (locally or via CI) and run the role gating tests to check no regressions.

## 4. Execution strategy & grounding snippets

Core idea: use a single, KISS file `nixos/roles.nix` that both declares the `roles` option (with a strict whitelist) and exposes a tiny helper factory `mkHelpers` that produces `hasRole`, `mkIfRole`, and `guardRole`. Import this module from the flake, call `mkHelpers roles` to obtain helpers, and inject them into `specialArgs` and `home-manager.extraSpecialArgs`. Modules should use the guard-first pattern (early-return) via `guardRole "X" { ... }` for clarity. If a module declares options, split options (always imported) from guarded implementation.

### 4.1 Unified roles module (single-file)

```nix
# nixos/roles.nix
{ lib, ... }:
let
  allowedDefault = [ "base" "wsl" "interactive" "dev" ];
  mkHelpers = roles:
    let
      hasRole = role: lib.elem role roles;
      mkIfRole = role: lib.mkIf (hasRole role);
      guardRole = role: block: if hasRole role then block else {};
    in { inherit hasRole mkIfRole guardRole; };
  module = {
    options.roles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of roles applied to this host.";
    };

    options.roles.allowed = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = allowedDefault;
      description = "Permitted roles; unknown roles cause evaluation failure.";
    };

    config = let unknown = lib.filter (r: !(lib.elem r config.roles.allowed)) config.roles;
             in if unknown == [] then {} else builtins.error ("Unknown roles: " + lib.concatStringsSep ", " unknown);
  };
in { inherit module mkHelpers; }
```

### 4.2 Host table + injection (example)

```nix
# nixos/flake.nix (concept snippet)
let
  const = import ./lib/const.nix;
  lib = nixpkgs.lib;
  rolesSpec = import ./roles.nix { inherit lib; };
  hosts = { nixos = { system = "x86_64-linux"; roles = [ "base" "wsl" "interactive" "dev" ]; }; };
in
{
  nixosConfigurations = lib.genAttrs (builtins.attrNames hosts) (hostName:
    let host = hosts.${hostName}; roles = host.roles; helpers = rolesSpec.mkHelpers roles; hasRole = helpers.hasRole;
    in
    lib.nixosSystem {
      system = host.system;
      specialArgs = { inherit const roles hostName; inherit (helpers) hasRole mkIfRole guardRole; };
      modules = [ rolesSpec.module (import ./lib/import-modules.nix { inherit (nixpkgs) lib; dir = ./system-modules; }) ]
                ++ lib.optionals (hasRole "wsl") [ nixos-wsl.nixosModules.default ];
      home-manager.extraSpecialArgs = { inherit roles hostName; inherit (helpers) hasRole mkIfRole guardRole; };
    }
  );
}
```

Notes: keep the single `nixos` host entry initially so behaviour is unchanged; future hosts default to `["base"]`.

### 4.3 Module gating (guard-first pattern)

```nix
# nixos/system-modules/wsl.nix (guarded)
{ config, const, lib, guardRole, ... }:
guardRole "wsl" {
  services.wsl.enable = true;
  services.wsl.defaultUser = const.user;
  services.wsl.useWindowsDriver = true;
}
```

```nix
# nixos/home-modules/nvim.nix (guarded)
{ config, lib, guardRole, ... }:
guardRole "dev" {
  programs.neovim.enable = true;
}
```

If a module defines options, split them into an always-imported `*-options.nix` and put the guarded implementation into `*-config.nix`.

### 4.4 packages-base / packages-dev (concrete split)

```nix
# nixos/system-modules/packages-base.nix
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ntfs3g
    openssh
    wget
    curl
    ripgrep
    fd
    gnutar
    unzip
  ];
}
```

```nix
# nixos/system-modules/packages-dev.nix
{ pkgs, guardRole, ... }:
guardRole "dev" {
  environment.systemPackages = with pkgs; [
    unrar
    cargo
    gnumake
    nodejs_24
    gcc
    (python313.withPackages (ps: [ ps.pip ]))
    go
    mermaid-cli
    lazygit
  ];
}
```

Notes: the NixOS module system concatenates `environment.systemPackages` lists from multiple modules, so base + dev merge naturally; use `lib.unique` if you need de-duplication.

## 5. Migration & roll-out steps (practical sequence)

1. Add `hosts` table and `specialArgs.roles` injection in `nixos/flake.nix` (single entry `nixos` with role list matching current config) and inject role helpers.
2. Create `nixos/system-modules/packages-base.nix` and `nixos/system-modules/packages-dev.nix` (see snippets).
3. Replace or rename current `packages.nix` to `packages-base.nix` and add `packages-dev.nix`.
4. Convert modules incrementally to use the guard-first pattern and helpers (e.g., use `guardRole "dev"` at the top of `nixos/home-modules/nvim.nix`), splitting options/configs when needed.
5. Gate `nixos-wsl` import at the flake level (only include it when `hasRole "wsl"`).
6. Add tests for role validation and gating; update CI to continue building `nixos` and run these tests.
7. Run CI/build for `nixos` to confirm no regressions.

## 6. Risks & mitigations

- Risk: moving dev packages into `packages-dev` will remove them from any host that does not have the `dev` role. Mitigation: keep WSL host (`nixos`) configured with `dev` until you explicitly remove it.
- Risk: subtle merge/dedupe issues for `environment.systemPackages`. Mitigation: if duplicates appear, use `lib.unique`.
