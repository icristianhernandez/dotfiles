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
