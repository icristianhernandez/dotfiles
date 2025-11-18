# dotfiles — NixOS + Home Manager + Neovim

This repository contains a personal NixOS + home-manager flake and a modular Neovim config built using Lua and lazy.nvim.

Overview

- Nix-first repository that manages a reproducible environment and Neovim configuration.
- Neovim config is modular, lazy-loaded, and includes tooling for LSPs, formatters, and linters.
- The repo uses Nix apps for CI, linting and formatting.

Repo layout

- nixos/ — Nix flake (nixos/flake.nix), home modules and system modules for dotfiles and CI tools.
  - home-modules/ — home-manager modules (nvim.nix, fish.nix, etc.)
  - system-modules/ — system-level configurations
  - apps/ — small Nix apps used by CI (nvim-ci, nvim-fmt, etc.)
- nvim/ — Neovim configuration
  - init.lua — bootstrap + lazy setup (nvim/init.lua)
  - lua/core/ — core runtime: options, keymaps, autocmds, lazy-setup, os and neovide helpers
  - lua/modules/ — plugin modules: ai, tooling, coding, ui, editor, colorscheme, experimental
  - lua/modules/extras/tooling.lua — single source of truth for LSPs, formatters, linters
  - spec/ — unit tests for Neovim modules (tooling_spec.lua)
- .github/workflows/ — CI definition that filters changes by path and runs scoped CI jobs
- AGENTS.md — repository guidelines and safe agent/maintainer rules
- notes/ — personal notes

Quick start (Nix users — recommended)

1. Clone the repo to your home directory (recommended for home-manager):
   git clone <your-fork-url> ~/dotfiles

2. Use the provided Nix apps for CI and maintenance:
   - Full CI: `nix run ./nixos#ci`
   - Neovim CI: `nix run ./nixos#nvim-ci`
   - Neovim fmt (format & stylua check): `nix run ./nixos#nvim-fmt`

3. Home Manager integration (home.nix / nixos/home-modules/nvim.nix expects `~/dotfiles/nvim`).

Quick start (Non-Nix users)

1. Clone repo somewhere and symlink the Neovim config:
   ln -s /path/to/repo/nvim ~/.config/nvim

2. Open Neovim: it will auto-bootstrap lazy.nvim and download plugins on first run.

Neovim configuration overview

- init.lua (nvim/init.lua) requires core.* modules and does lazy setup.
- lazy-setup.lua handles lazy.nvim bootstrapping and plugin spec import (modules).
- core/options.lua sets editor options (line numbers, tabs, wrap, etc.).
- core/keymaps.lua centralizes keymaps using a small create_keymap wrapper.
- core/autocmds.lua contains autocommands for convenience and small UX improvements.
- core/neovide.lua and core/wsl.lua contain platform-specific adjustments.
- Plugin modules are organized in lua/modules/*.lua, grouped by purpose (ui, editor, coding, tooling, ai, etc.).

Tooling: LSPs / formatters / linters (single source of truth)

- `lua/modules/extras/tooling.lua` defines tool "stacks" (lua, frontend_web, data_and_docs, nix, shell, python, c_cpp, databases) and a builder function.
- The builder (M.build) merges stacks to produce:
  - mason_lspconfig.ensure_installed
  - mason_lspconfig.automatic_enable
  - conform.formatters_by_ft
  - mason_null_ls.ensure_installed
  - null_ls.init (manual registrations for null-ls)
- Tooling consumers (e.g., modules/tooling.lua) import `require('modules.extras.tooling').tooling` and use it to configure Mason, Conform and Null-LS.

Tests

- Unit tests for tooling are provided with plenary/busted in nvim/spec/tooling_spec.lua.
- Run tests locally with:
  nvim --headless -u nvim/init.lua -c "lua require('plenary.busted').run('nvim/spec/tooling_spec.lua')" -c "qa"

CI and format checks

- CI uses a path filter and runs per-domain jobs. See `.github/workflows/ci.yml`.
- Common CI commands:
  - `nix run ./nixos#nvim-ci` — Run Neovim-specific checks (stylua, style checks)
  - `nix run ./nixos#nvim-fmt` — Format the Neovim code with stylua
  - `nix run ./nixos#ci` — Run the full CI pipeline for all domains

Development & conventions

- Lua style:
  - Use snake_case for locals and variables.
  - Kebab-case for filenames.
  - Modules should return tables or functions; avoid global mutations.
- Plugin modules should be small, focus on one responsibility and rely on M.tooling for tooling sets.
- Respect `nvim/.stylua.toml` for formatting (indent_width = 4, column_width = 120).
- Do not edit `lazy-lock.json` or other lockfiles unless you explicitly intend to update them.
- If you change Neovim modules, run: `nix run ./nixos#nvim-ci` before opening a PR.

Contributing

- Create feature branches for changes and follow the repo style.
- Run the Neovim CI locally and make sure tests pass before proposing changes.
- If adding tooling stacks, add tests to `nvim/spec/tooling_spec.lua`.

Notes & extras

- WSL and Neovide have platform-specific tweaks in core modules (core/wsl.lua and core/neovide.lua).
- This repository is intended as a reproducible dotfiles setup; be mindful of system-specific paths and process details when editing nix modules.

License

- MIT — see LICENSE
