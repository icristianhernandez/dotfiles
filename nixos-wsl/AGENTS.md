# AGENTS.md

## Repository Conventions

### Build, Lint, Check

- Do not rebuild NixOS runtime here.
- NixOS CI: `nix run ./nixos-wsl#apps.x86_64-linux.nixos-ci`
- The CI format the config and run checks.

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

- Run the subdomain CI (apply fmt and runs checks) after every change:
  - `nix run ./nixos-wsl#apps.x86_64-linux.nixos-ci`
- Fix all issues before finishing, so always run the CI.
- Reuse `lib/const.nix` for shared values.
- If flake checks need staged files, ask user to prepare the repo (important).

### Agent Operational Rules

- Never run/suggest VCS operations; ask user to prepare repo state.
- Run checks after edits; do not conclude until passing or user
  accepts failures (first format, next ci).
- Do not update `nixos-wsl/flake.lock`.
