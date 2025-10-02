# AGENTS.md

## Repository Conventions

### Build, Lint, Check

- Formatting: `stylua ~/dotfiles/nvim/` (whole config).
- Lint: `luacheck ~/dotfiles/nvim/`.

### Structure & Style

- Use the repository `.stylua.toml` (4 spaces, 120 cols, AutoPrefer
  DoubleQuotes).
- Imports: `local mod = require('module')` at the top of the file.
  Prefer `local` scope for definitions.
- Naming: use `snake_case` for local variables and functions.
  Keep existing `kebab-case` filenames in `lua/` where present.
- Modules: return a table or function from module files.
  Avoid polluting globals (`vim.g` or `_G` only when intentional).
- Annotations: use EmmyLua annotations (`---@param`, `---@return`,
  `---@class`) to improve LSP typing and completion.
- Error handling: guard optional requires with
  `local ok, mod = pcall(require, 'mod')` and handle failures
  gracefully.
- Plugins: follow `lazy.nvim` plugin spec; plugin files should
  return a table and be placed under `lua/plugins/`.
- Keep modules small and focused; prefer composition and clear
  separation of responsibilities.

### Workflow Hygiene

- The Neovim config lives under `nvim/.config/nvim/` with Lua code in
  `lua/` and plugin specs in `lua/plugins/`.
- Stylua config is at `nvim/.config/nvim/.stylua.toml`.
- The default branch is `main`; never commit, push, or stage files,
  nor suggest doing so, unless instructed by the user.
- Always finish by running formats and lintings before
  claiming the task is complete.
