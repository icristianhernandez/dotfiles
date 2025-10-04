# AGENTS.md

## Repository Conventions

### Build, Lint, Check

- Neovim CI: `nix run ./nixos-wsl#apps.x86_64-linux.nvim-ci`
  - That CI unify handle fmt, lints, checks, etc., in all the config.
  - As a agent, always use that command for related actions and NEVER do
        alternatives.
  - That command is safe to run in any mode.

### Structure & Style

- Neovim config: `nvim/.config/nvim/` with Lua in `lua/`.
- Stylua config: `nvim/.config/nvim/.stylua.toml`.
- Plugins: follow `lazy.nvim` spec under `lua/plugins/`.
- Use `snake_case` for locals; keep kebab-case filenames.
- Return a table or function from modules; avoid globals.
- Keep modules small and focused.

### Workflow Hygiene

- Run the subdomain CI after every change:
  - `nix run ./nixos-wsl#apps.x86_64-linux.nvim-ci`
- Fix all issues before finishing.

### Agent Operational Rules

- Never run/suggest VCS operations; ask user to prepare repo.
- Run formatting after edits; do not conclude until passing.
- Do not edit `lazy-lock.json`.
