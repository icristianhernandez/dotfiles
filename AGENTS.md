# Dotfiles for a NixOS-on-WSL setup using Nix flakes and Home

Manager, plus curated Neovim, shell, and developer tooling configs

## Technologies

- Nix/NixOS/WSL: Nix flake (`flake.nix/lock`); NixOS on WSL;
  Home Manager modules.
- Neovim: Lua config with Lazy.nvim/LazyVim.
  Notable plugins: Treesitter, LSP, Lualine, Copilot, Noice,
  Blink, Snacks (picker/terminal/words), mini.files,
  indent-blankline, vim-matchup, rainbow-delimiters,
  smart-splits, hardtime, nvim-surround.
- Shell & Terminal: fish config; Starship prompt.
- Tooling & Utilities: yazi, git config, SSH agent.
- CI & Lint/Format: GitHub Actions; statix + deadnix; nixfmt RFC;
  Stylua.
- Other languages/tools: none detected (no Node/TypeScript, Rust,
  Python/Flask, Docker, Go).

## Paths

- NixOS + Home Manager: `nixos-wsl/system-modules/*`,
  `nixos-wsl/home-modules/*`, plus `configuration.nix`, `home.nix`,
  `nixos-wsl/lib/*`.
- Neovim: `nvim/.config/nvim/*` (plugins in `lua/plugins/*.lua`,
  settings in `lua/config/*.lua`, Stylua at `.stylua.toml`).
- Shell: `fish/.config/fish/*`; Prompt:
  `starship/.config/starship.toml`.
- CI: `.github/workflows/ci.yml`; Lint/format config:
  `nixos-wsl/lib/checks.nix`, `statix.toml`.

## Commands

- Checks: `nix flake check ./nixos-wsl -L`
- Format: `nix run ./nixos-wsl#formatter.x86_64-linux -- --ci`
  (local: `nix run ./nixos-wsl#formatter.x86_64-linux`)
- Workflow lint (actionlint): `nix run nixpkgs#actionlint -- .github/workflows`
- Workflow YAML lint (yamllint): `nix run nixpkgs#yamllint -- .github/workflows`
  (no dedicated `.yamllint.yml` rules provided in this repo)

## Agent Conventions

- The default branch is `main`; never commit, push, or stage files,
  nor suggest doing so, unless instructed by the user.

- Subconfig agent guidance: For changes in NixOS or Neovim subconfigs, follow their AGENTS instructions:
  - `nixos-wsl/AGENTS.md` for `nixos-wsl/**`
  - `nvim/.config/nvim/AGENTS.md` for `nvim/.config/nvim/**`

  These files define conventions and rules for their areas.
