# AGENTS.md

## Build, Lint, and Test Commands

- **Validate config:**
  - `nix flake check` (run this to check all changes; required for validation)
- **Testing:**
  - No traditional unit tests or linter; validation is only via `nix flake check`.
  - Never run `nixos-rebuild`, `build`, or `dry-activate` as an agent.

## Code Style Guidelines

- Use 2 spaces for indentation (Nix standard)
- Prefer explicit imports; keep modules and options modular and clear
- Use snake_case for variables/options, PascalCase for module names
- Comment all non-obvious logic and option overrides
- Group related options; keep sections organized and readable
- Use `with pkgs; [ ... ]` for package lists
- Check exit codes in shell scripts for error handling
- Avoid trailing whitespace; keep lines < 100 chars
- All changes must be idempotent and reproducible

## Agent Notes

- This repo is a NixOS/WSL config using Nix flakes, Home Manager and WSL
- Agents must only use `nix flake check` for validation
