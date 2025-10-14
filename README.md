# Dotfiles: NixOS-on-WSL with Flakes, Home Manager, and Neovim

Opinionated NixOS-on-WSL setup managed with Nix flakes and Home Manager, plus a curated Neovim, shell, and developer tooling configuration. Local and CI flows share a single, unified entrypoint.

## Features

- NixOS on WSL with Home Manager modules and shared constants
- Single-command CI for all domains (NixOS, Neovim, GitHub workflows)
- Neovim with Lazy.nvim and LazyVim, prewired LSP/treesitter and sensible defaults
- Fish shell and Starship prompt, plus common dev tools (ripgrep, fd, nvimpager)
- Declarative SSH agent, Git identity, and system defaults

## Tech Stack

- Nix/NixOS/WSL: flake, NixOS-WSL, Home Manager
- Neovim: Lua config via Lazy.nvim + LazyVim
- Shell: fish, Starship
- Tools: yazi, SSH agent
- CI: GitHub Actions; local `nix run` apps for fmt/lint/check

## Repository Layout

- NixOS + Home: `nixos/system-modules/*`, `nixos/home-modules/*`, `nixos/lib/*`, `nixos/apps/*`, `nixos/configuration.nix`, `nixos/home.nix`, `nixos/flake.nix`
- Neovim: `nvim/.config/nvim/*` (plugins in `lua/plugins/*.lua`, settings in `lua/config/*.lua`)
- CI: `.github/workflows/ci.yml`
- Notes: `notes/*`

## Requirements

- A machine with WSL (Windows Subsystem for Linux)
- Nix with flakes enabled (CI uses Determinate Systems installer)

## Quick Start

- Run the unified CI locally (formats, lints, checks all domains):

  - `nix run ./nixos#ci`

- Domain-specific entry points are also available if needed:
  - NixOS: `nix run ./nixos#nixos-ci`
  - Neovim: `nix run ./nixos#nvim-ci`
  - Workflows: `nix run ./nixos#workflows-ci`

## NixOS + Home Manager

- Entry points: `nixos/flake.nix`, `nixos/configuration.nix`, `nixos/home.nix`
- Modules are auto-imported from:
  - System: `nixos/system-modules/` (core, locale, packages, shell, users, wsl)
  - Home: `nixos/home-modules/` (nvim, fish, git, starship, yazi, ssh-agent)
- Shared constants live in `nixos/lib/const.nix` (user, locale, state version, git identity)
- Highlights:
  - `programs.nix-ld` enabled with common libraries
  - Fish enabled; Bash shells exec Fish interactively; Starship with `bracketed-segments`
  - Core CLI/dev tools available system-wide (neovim, opencode, nvimpager, ripgrep, fd, etc.)
  - Neovim config is linked out-of-store from this repo via Home Manager

## Neovim Configuration

- Config root: `nvim/.config/nvim/` with `init.lua` bootstrapping Lazy.nvim
- Plugin management: Lazy.nvim; base preset via LazyVim; custom plugins under `lua/plugins/`
- Treesitter: enabled; incremental selection bound to `<CR>`/`<bs>`; context lines via `nvim-treesitter-context`
- LSP:
  - Defaults tuned via LazyVim
  - Web stack: `html`, `cssls`, `biome`, `ts_ls`, with `denols` detection
  - Python: `basedpyright`
  - Optional/personal: a `pseint-lsp` entry points at a hard-coded path; remove or adjust as needed
- Formatting: Stylua with `.stylua.toml`; CI runs `stylua --check`

## Shell and Tooling

- Fish with a `clearnvim` helper to purge Neovim caches
- Starship prompt with bracketed segments preset
- Pagers: `nvimpager` set for `PAGER`, `MANPAGER`, and `GIT_PAGER`
- SSH: `programs.ssh` configured with AddKeysToAgent=ask; `keychain` integration for `id_ed25519`

## CI

- Local: run everything with `nix run ./nixos#ci`
- GitHub Actions: `.github/workflows/ci.yml` runs on path filters for `nixos/**`, `nvim/**`, and workflows; uses Determinate Systems Nix installer and cache
- Sub-CIs:
  - `nixos-ci`: format, lint, and `nix flake check` under `nixos/`
  - `nvim-ci`: Stylua check after enforcing formatting
  - `workflows-ci`: `actionlint` + `yamllint`

## Contributing

- Follow the agent conventions in the AGENTS docs:
  - Root: `AGENTS.md`
  - Nix: `nixos/AGENTS.md`
  - Neovim: `nvim/.config/nvim/AGENTS.md`
- Keep changes declarative; avoid secrets and environment access in Nix
- Do not modify lock files as part of routine changes

## Security

- No secrets are committed to the repo. Avoid `builtins.getEnv` for secrets. Use OS keyrings or external secret managers.

## Troubleshooting

- Neovim plugins are managed by Lazy.nvim and installed on first launch
- If Neovim misbehaves, try clearing caches: `fish -c clearnvim`
- The `pseint-lsp` entry is optional; comment it out or adjust the `cmd` path if not present

## License

- See `LICENSE` for details.
