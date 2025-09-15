# AGENTS.md

## Build, Lint, and Test Commands

- **Dev shell:**
  - `nix develop` or `nix-shell`
- **Check flake/config validity:**
  - `nix flake check` (use this to validate changes)
- **Apply system config:**
  - `sudo nixos-rebuild switch --flake .#<hostname>` (do not run as agent)
- **Build without switching:**
  - `sudo nixos-rebuild build --flake .#<hostname>` (do not run as agent)
- **Dry-run activation:**
  - `sudo nixos-rebuild dry-activate --flake .#<hostname>` (do not run as agent)
- **Testing:**
  - No traditional unit tests; validate by building or switching configs. Use `nix flake check` for automated validation.

## Code Style Guidelines

- 2 spaces for indentation (Nix standard)
- Prefer explicit imports; keep structure modular and clear
- Use snake_case for variables/options, PascalCase for module names
- Comment all non-obvious logic and option overrides
- Group related options; keep sections organized
- Use `with pkgs; [ ... ]` for package lists
- Check exit codes in shell scripts for error handling
- Avoid trailing whitespace; keep lines < 100 chars
- All changes must be idempotent and reproducible

## Agent Notes

- This repo (a daily drive nixos config) uses Nix flakes, Home Manager, and Plasma Manager modules
- Agents must never run `nixos-rebuild switch`, `build`, or `dry-activate`
- Agents should only check config validity with `nix flake check`
- No Cursor or Copilot rules are present
