# AGENTS.md

## Repository Conventions

### Build, Lint, Check

- Never rebuild the NixOS config.
- Formatting: `nix fmt` (runs `nixfmt`/`treefmt` across all `.nix` files;
  the flake `formatter` is set to `nixfmt-tree`).
- Checks: `nix flake check`; linting is also checked using statix and deadnix.
- No unit tests are defined.

### Structure & Style

- Modules live in `system-modules/` and `home-modules/`, auto-imported by
  `lib/import-directory.nix`.
- `lib/import-directory.nix` keep module imports deterministic and sorted.
- Shared constants reside in `lib/const.nix`; update once to propagate
  everywhere.
- Entry points: `configuration.nix`, `home.nix`, and `flake.nix`.
- `programs.nix-ld` is enabled to support foreign binaries and the dev
  toolset is global. That is intended and any related changes need to
  comply with that schema.
- (Neovim, Starship) config lives out of store via
  `mkOutOfStoreSymlink`.
- Format with `nixfmt`.
- Module Arguments: Only bind arguments that are actually used. If no
  argument is used, use `_:`.
- Write idiomatic Nix — use explicit strings. For example, use `rec` sets
  for shared data, and `lib.mkDefault` for defaults.
- File names use kebab-case; attributes use lower_snake_case; lists are one
  item per line with locally scoped `with pkgs; [ ... ]` when needed.
- Configure options declaratively; avoid side-effects and imperative
  commands. Avoid using dynamic `builtins.getEnv` where possible.

### Workflow Hygiene

- The default branch is `main`; never commit, push, or stage files,
  nor suggest doing so, unless instructed by the user.
- Reuse `const` to keep modules lean and evaluation deterministic.
- Always finish by running `nix fmt` and `nix flake check` before
  claiming the task is complete.
