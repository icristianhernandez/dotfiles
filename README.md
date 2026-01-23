# dotfiles

Personal NixOS + Home Manager + Neovim configuration for WSL and desktop hosts.

## Tech stack

- NixOS Flake (Nixpkgs `nixos-25.11` + `nixos-unstable` overlay)
- Home Manager (release `25.11`)
- NixOS WSL module (`nix-community/nixos-wsl` release `25.11`)
- Neovim config in Lua (tested with Neovim `0.11.5`)
- Nix apps for CI helpers (nixfmt, statix, deadnix, stylua, actionlint, yamllint)

## Requirements

- Nix with flakes enabled
- Linux `x86_64` (flake systems list is `x86_64-linux` only)
- For WSL hosts: WSL-enabled environment
- For desktop host profile: ThinkPad E14 Gen 2 (Intel i5-1135G7) specific modules are present

## Repository structure

- `nixos/` — NixOS flake, system modules, and Home Manager modules
- `nvim/` — Neovim configuration in Lua
- `.github/workflows/` — CI workflows that call Nix apps
- `scripts/` — helper shell scripts
- `opencode/` — OpenCode configuration

### NixOS layout

- `nixos/flake.nix` — flake entrypoint and host definitions
- `nixos/system-modules/` — system-level modules (roles, hardware, desktop, WSL)
- `nixos/home-modules/` — Home Manager modules (shell, tools, apps, theming)
- `nixos/apps/` — CI helpers and format/lint apps
- `nixos/roles.nix` — role definitions and helpers

### Neovim layout

- `nvim/init.lua` — entrypoint
- `nvim/lua/core/` — options, keymaps, OS/WSL handling, lazy setup
- `nvim/lua/modules/` — plugin group definitions

## Host definitions

Defined in `nixos/flake.nix`:

- `wsl` — base + interactive + dev + wsl
- `dmsdesktop` — base + interactive + dev + desktop + thinkpadE14 + dms + gaming
- `gnomedesktop` — base + interactive + dev + desktop + thinkpadE14 + gnome + gaming

## Design decisions (facts only)

- Hosts are composed by role lists (`nixos/roles.nix`) and role helpers (`hasRole`, `mkIfRole`, `guardRole`).
- System modules and Home Manager modules are auto-imported from their directories via `nixos/lib/import-modules.nix`.
- `nixos-wsl` is conditionally imported for hosts that carry the `wsl` role.
- `nixos-unstable` is exposed through an overlay as `pkgs.unstable`.

## Usage

### Build or switch a host

```bash
sudo nixos-rebuild switch --flake ./nixos#<host>
```

Examples:

- `sudo nixos-rebuild switch --flake ./nixos#wsl`
- `sudo nixos-rebuild switch --flake ./nixos#dmsdesktop`
- `sudo nixos-rebuild switch --flake ./nixos#gnomedesktop`

### Run CI locally (Nix apps)

```bash
nix run ./nixos#ci
```

Per-domain checks:

- `nix run ./nixos#nixos-ci`
- `nix run ./nixos#nvim-ci`
- `nix run ./nixos#workflows-ci`

### Format/Lint (individual apps)

- `nix run ./nixos#nixos-fmt`
- `nix run ./nixos#nixos-lint`
- `nix run ./nixos#nvim-fmt`
- `nix run ./nixos#workflows-lint`

## Scripts

- `scripts/create-ssh-keys.sh` — interactive GitHub SSH key generator
- `scripts/git-auto-commit-opencode.sh` — OpenCode-based conventional commit helper

## CI

The GitHub workflow (`.github/workflows/ci.yml`) runs per-path checks:

- `nixos-ci` when `nixos/**` changes
- `nvim-ci` when `nvim/**` changes
- `workflows-ci` when `.github/workflows/**` changes

## Notes

- State versions: `systemState` and `homeState` are `25.11` in `nixos/lib/const.nix`.
- User home and dotfiles directory are defined in `nixos/lib/const.nix` (`/home/cristian/dotfiles`).

## License

See `LICENSE`.
