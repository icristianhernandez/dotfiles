# dotfiles - NixOS + Home Manager + Neovim

A reproducible NixOS/Home Manager flake with a modular, lazy-loaded Neovim config (Lua + lazy.nvim).

## Quick start (Nix users)

- Clone: git clone <your-fork-url> ~/dotfiles
- Run Nix apps (CI / checks / formatters):
  - Full CI: `nix run ./nixos#ci`
  - Neovim checks: `nix run ./nixos#nvim-ci`
  - Format Neovim code: `nix run ./nixos#nvim-fmt`
- Home Manager: home modules expect `~/dotfiles/nvim`; `nixos/home-modules/nvim.nix` symlinks `${const.dotfiles_dir}/nvim` (see `nixos/lib/const.nix`).

## Quick start (Non-Nix)

- Symlink Neovim config: `ln -s /path/to/repo/nvim ~/.config/nvim`
- Open Neovim to auto-bootstrap plugins.

## Repo layout

- `nixos/` - Nix flake (`nixos/flake.nix`), home- and system-modules, CI apps (`nixos/apps`).
- `nvim/` - Neovim config (`init.lua`, `lua/core`, `lua/modules`, `spec/`).
- `.github/workflows/` - CI job definitions.
- `AGENTS.md`, `notes/`, `LICENSE`.

## Highlights

- `nvim/init.lua` bootstraps lazy.nvim and loads core modules (options, keymaps, autocmds).
- Tooling single-source: `lua/modules/extras/tooling.lua` defines stacks and the builder function. The builder exposes:
  - `mason_lspconfig.ensure_installed`
  - `mason_lspconfig.automatic_enable`
  - `conform.formatters_by_ft`
  - `mason_null_ls.ensure_installed`
  - `null_ls.init`
  - `treesitter.ensure_installed`
- WSL & Neovide: platform tweaks live in `nvim/lua/core/wsl.lua` and `nvim/lua/core/neovide.lua`.
- Tests: `nvim/spec/tooling_spec.lua` (plenary/busted).

## Testing

Run unit tests for tooling:

```bash
nvim --headless -u nvim/init.lua -c "lua require('plenary.busted').run('nvim/spec/tooling_spec.lua')" -c "qa"
```

## Contributing

- Run `nix run ./nixos#nvim-ci` and tests locally before proposing changes.

## License

MIT
