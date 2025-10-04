# AGENTS.md

## Repository Conventions

### Build, Lint, Check

- Neovim CI (stylua): `nix run ./nixos-wsl#apps.x86_64-linux.nvim-ci`
- The CI format the config and run checks.

### Structure & Style

- Neovim config: `nvim/.config/nvim/` with Lua in `lua/`.
- Stylua config: `nvim/.config/nvim/.stylua.toml`.
- Plugins: follow `lazy.nvim` spec under `lua/plugins/`.
- Use `snake_case` for locals; keep kebab-case filenames.
- Return a table or function from modules; avoid globals.
- Keep modules small and focused.

### Workflow Hygiene

- Run the unified CI which applies formatting in each subdomain CI and then runs checks:
  - `nix run ./nixos-wsl#apps.x86_64-linux.nvim-ci`
- Fix all issues before finishing, unless the user explicitly accepts outstanding failures.

### Agent Operational Rules

- Never run/suggest VCS operations; ask user to prepare repo.
- Run formatting after edits; do not conclude until passing.
- Do not edit `lazy-lock.json`.
