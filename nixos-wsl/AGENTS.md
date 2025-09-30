# AGENTS.md

## Build, Lint, and Check

- **Build system:**
  - Never rebuild the config, even if the user ask for it.
- **Format/lint:**
  - `nix fmt` (treefmt wrapper; uses `nixfmt`)
- **Checks:**
  - `nix flake check` (runs formatting check, plus advisory statix/deadnix)
  - Style: `nix run nixpkgs#statix -- check .` and `nix run nixpkgs#deadnix -- .`
- **Unit tests:** None present.

## Code Style & Structure

- **File layout:**
  - Nix modules: `system-modules/`, `home-modules/`. All auto imported in
  `configuration.nix` and `home.nix`.  
  - Constants: `lib/const.nix`
  - Deterministic imports: `lib/import-directory.nix`
  - Entry points in: `configuration.nix`, `home.nix`, `flake.nix`
- **Formatting:**
  - Use `nixfmt` via treefmt; run `nix fmt` before commits.
- **Imports:**
  - Prefer `import ./lib/import-directory.nix { dir = ./<dir>; }`
  - Keep `.nix` files sorted deterministically.
- **Types:**
  - Write idiomatic Nix; avoid implicit strings.
  - Use `rec` and attribute sets for shared constants.
- **Naming:**
  - kebab-case filenames; lower_snake_case for attrs (e.g., `home_dir`)
- **Module args:**
  - Use `{ config, pkgs, const, ... }:`; pass `const` via `specialArgs`/`extraSpecialArgs`.
- **Options:**
  - Set NixOS/Home Manager options declaratively; avoid imperative commands.
- **Error handling:**
  - Validate options at eval time; avoid dynamic `builtins.getEnv` or side effects.
  - Use `lib.mkDefault` for defaults.
- **Git:**
  - Default branch: `main`.
  - Don't commit.
  - Don't push.
  - Don't add staged. You probably are going to need add files to run checks,
  ask the user.
- **WSL:**
  - System enables `wsl` module; default user from `const.user`.
- **Performance:**
  - Keep modules small; reuse `const` for shared values; avoid repeated eval work.
- **Conventions:**
  - One option group per file when reasonable; lists: one item per line;
  prefer `with pkgs; [ ... ]` scoped locally.
- **Changes hygiene:**
  - Run `nix fmt` and `nix flake check` before finish doing changes.

## Notable Technical Decisions

- **Deterministic auto-import of modules:**
  All `.nix` files in `system-modules/` and `home-modules/` are auto-imported in lexicographic order via `lib/import-directory.nix`. To add a module, simply drop it in the directory—manual wiring is not needed, and evaluation order is stable.

- **Centralized constants:**
  Shared values (user, home_dir, state versions, locale, git identity) are defined in `lib/const.nix` and passed to all modules via `specialArgs`/`extraSpecialArgs`. Change once, propagate everywhere.

- **nix-ld for binary compatibility:**
  `programs.nix-ld` is enabled with a broad set of libraries, allowing foreign dynamically linked binaries (e.g., prebuilt tools) to run out-of-the-box. This increases compatibility at the cost of a larger runtime surface.

- **Dotfiles (Neovim) managed outside the Nix store:**
  Neovim config is symlinked from `~/dotfiles/nvim/.config/nvim/` using `mkOutOfStoreSymlink`, so it remains editable and version-controlled outside the Nix store. Home Manager only manages the link.

- **Global developer toolset:**
  A rich set of developer tools (compilers, Python, Node, Neovim, opencode, etc.) is globally installed for all users, resulting in a larger closure but a ready-to-use dev environment.
