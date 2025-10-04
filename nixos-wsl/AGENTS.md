# AGENTS.md

## Repository Conventions

### Build, Lint, Check

- Do not rebuild NixOS runtime here.
- NixOS format (fix): `nix run ./nixos-wsl#apps.x86_64-linux.nixos-fmt`
- NixOS CI: `nix run ./nixos-wsl#apps.x86_64-linux.nixos-ci`
- Orchestrator (all domains): `nix run ./nixos-wsl#apps.x86_64-linux.ci`

### Structure & Style

- Shared constants: `lib/const.nix`.
- Modules: `system-modules/` and `home-modules/` auto-imported via
  `lib/import-directory.nix`.
- Apps location: `nixos-wsl/apps/` (app modules such as `fmt.nix`, `lint.nix`, `ci.nix`)
- Entry points: `configuration.nix`, `home.nix`, `flake.nix`.
- `programs.nix-ld` is enabled; keep changes compatible with schema.
- Neovim, Fish, Starship out-of-store via `mkOutOfStoreSymlink`.
- Use kebab-case for filenames; `lower_snake_case` for attributes.
- Keep lists one-item-per-line when needed.
- Configure declaratively; avoid `builtins.getEnv` for secrets.

### Workflow Hygiene

- Reuse `lib/const.nix` for shared values.
- Run format, next ci after edits.
- If flake checks need staged files, ask user to prepare the repo (important).

### Agent Operational Rules

- Never run/suggest VCS operations; ask user to prepare repo state.
- Run checks after edits; do not conclude until passing or user
  accepts failures (first format, next ci).
- Do not update `nixos-wsl/flake.lock`.
