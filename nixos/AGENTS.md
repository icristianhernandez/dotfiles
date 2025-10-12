# AGENTS.md

## Repository Conventions

### Build, Lint, Check

- As a agent, you are forbidden of do any build or rebuild.
- NixOS CI: `nix run ./nixos#nixos-ci`
  - That CI unify handle fmt, lints, checks, etc., in all the config.
  - As a agent, always use that command for related actions; never use another.
  - That command is safe to run in any mode.

### Structure & Style

- Shared constants: `lib/const.nix`.
- Modules: `system-modules/` and `home-modules/` auto-imported via `lib.filesystem.listFilesRecursive` and filtered for `.nix` files.
- Apps location: `nixos/apps/` (app modules such as `fmt.nix`, `lint.nix`, `ci.nix`)
- Entry points: `configuration.nix`, `home.nix`, `flake.nix`.
- `programs.nix-ld` is enabled; keep changes compatible with schema.
- Neovim config is linked out-of-store from this repo (repo-relative symlink). Fish and Starship are managed via Home Manager modules (no repo symlinks).
- Use kebab-case for filenames; `lower_snake_case` for attributes.
- Keep lists one-item-per-line when needed.
- Configure declaratively; avoid `builtins.getEnv` for secrets.

### Workflow Hygiene

- Run the subdomain CI (apply fmt and runs checks) after every change:
  - `nix run ./nixos#nixos-ci`
- Fix all issues before finishing, so always run the CI.
- Reuse `lib/const.nix` for shared values.
- If flake checks need staged files, ask user to prepare the repo (important).
- Never do adds or commits by yourself, always ask the user and await for it.

### Agent Operational Rules

- Never run/suggest VCS operations; ask user to prepare repo state.
- Never run/suggest system-altering commands; ask the user to perform these actions instead.
- Run checks after edits; do not conclude until passing or user
  accepts failures (first format, next ci).
- Do not update `nixos/flake.lock`.
