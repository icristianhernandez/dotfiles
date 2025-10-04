# AGENTS.md

## Repository Conventions

### Build, Lint, Check

- Neovim format (fix): `nix run ./nixos-wsl#apps.x86_64-linux.nvim-fmt`
- Neovim CI (stylua --check): `nix run ./nixos-wsl#apps.x86_64-linux.nvim-ci`

### Structure & Style

- Plugins: follow `lazy.nvim` spec under `lua/plugins/`.
- Use `snake_case` for locals; keep kebab-case filenames.
- Return a table or function from modules; avoid globals.
- Keep modules small and focused.

### Workflow Hygiene

- Neovim config: `nvim/.config/nvim/` with Lua in `lua/`.
- Stylua config: `nvim/.config/nvim/.stylua.toml`.
- Run formatting for changed Lua files before finishing.

### Agent Operational Rules

- Never run/suggest VCS operations; ask user to prepare repo.
- Run formatting after edits; do not conclude until passing.
- Do not edit `lazy-lock.json`.
