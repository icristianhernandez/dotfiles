# Missing Features Analysis: nvim-deprecated → nvim

This document tracks functionalities from the old configuration (`nvim-deprecated/`) that have not been migrated to the new configuration (`nvim/`).

**Last Updated:** 2025-11-23

---

## Missing Plugins

### 1. CodeCompanion (AI Chat Interface)
- **Plugin:** `olimorris/codecompanion.nvim`
- **Old Location:** `nvim-deprecated/lua/plugins/codecompanion.lua`
- **Functionality:**
  - AI chat interface for code assistance
  - Custom keybindings: `<leader>aa` (action), `<leader>ai` (insert), `<leader>ac` (commit)
  - Command abbreviations: `cc`, `cC`, `Cc`, `CC` → `CodeCompanion`
  - Visual mode integration with `ga` to add selection to chat
- **New Alternative:** Uses `opencode.nvim` instead, which has different features
- **Status:** ❌ Not migrated (different tool with different capabilities)

### 2. Tabout (Context Exit in Insert Mode)
- **Plugin:** `abecodes/tabout.nvim`
- **Old Location:** `nvim-deprecated/lua/plugins/tabout.lua`
- **Functionality:**
  - Exit brackets/quotes/tags in insert mode
  - Keybindings: `<C-x>` (forward), `<C-z>` (backward)
  - Multi-character tabout support
- **Status:** ❌ Not migrated

### 3. Vim-Matchup (Enhanced % Matching)
- **Plugin:** `andymass/vim-matchup`
- **Old Location:** `nvim-deprecated/lua/plugins/vim-matchup.lua`
- **Functionality:**
  - Enhanced `%` matching with Treesitter integration
  - Offscreen matchparen popup
  - Transmute capability
  - Highlight surround with `<leader>ci`
- **New Location:** Commented out in `nvim/lua/modules/experimental.lua`
- **Status:** ⚠️ Present but disabled (needs to be uncommented to restore)

### 4. Vimade (Inactive Window Dimming)
- **Plugin:** `tadaa/vimade`
- **Old Location:** `nvim-deprecated/lua/plugins/vimade.lua`
- **Functionality:**
  - Dim inactive windows/buffers
  - Toggle with `<leader>uv` (via Snacks toggle)
  - Non-animated fade
- **New Location:** Commented out in `nvim/lua/modules/experimental.lua`
- **Status:** ⚠️ Present but disabled (needs to be uncommented to restore)

### 5. PSeInt Language Support
- **Plugin:** `EddyBer16/pseint.vim`
- **Old Location:** `nvim-deprecated/lua/plugins/temporary-pseint.lua`
- **Functionality:**
  - Syntax highlighting for PSeInt pseudocode
  - Custom LSP configuration in old lsp.lua
- **Status:** ❌ Not migrated (marked as temporary in old config)

---

## Missing LazyVim Extra Features

### 6. Mini-Comment
- **LazyVim Extra:** `lazyvim.plugins.extras.coding.mini-comment`
- **Functionality:** Commenting with `gc` operator
- **New Alternative:** Uses `folke/ts-comments.nvim` (Treesitter-based commenting)
- **Status:** ✅ **Replaced with improved alternative** (ts-comments is more modern)

### 7. Harpoon2
- **LazyVim Extra:** `lazyvim.plugins.extras.editor.harpoon2`
- **Functionality:** Quick file marking and navigation
- **New Alternative:** Uses `cbochs/grapple.nvim` (similar file marking)
- **Status:** ✅ **Replaced with similar alternative** (grapple provides file tagging)

### 8. Mini-Hipatterns
- **LazyVim Extra:** `lazyvim.plugins.extras.util.mini-hipatterns`
- **Functionality:** Highlight patterns in text (hex colors, TODOs, etc.)
- **Status:** ❌ Not migrated
- **Note:** New config has `catgoose/nvim-colorizer.lua` for hex colors but not full hipatterns

### 9. Dot Language Support
- **LazyVim Extra:** `lazyvim.plugins.extras.util.dot`
- **Functionality:** GraphViz DOT language support
- **Status:** ❌ Not migrated (no DOT parser or LSP in tooling.lua)

---

## Features with Full Parity

The following LazyVim extras and old plugins have been successfully migrated:

### Editor Features
- ✅ **inc-rename** → Present in new config (via noice.nvim dependency)
- ✅ **mini-files** → Present in new config
- ✅ **mini-move** → Present in new config
- ✅ **snacks_picker** → Present in new config (comprehensive picker setup)

### UI Features
- ✅ **indent-blankline** → Present in new config
- ✅ **smear-cursor** → Present in new config
- ✅ **treesitter-context** → Present in new config

### Language Support (All Migrated)
- ✅ **clangd** (C/C++) → In tooling.lua
- ✅ **git** → In tooling.lua (VCS parsers and linters)
- ✅ **json** → In tooling.lua (with SchemaStore)
- ✅ **markdown** → In tooling.lua (marksman LSP, formatters, linters)
- ✅ **python** → In tooling.lua (ruff + basedpyright)
- ✅ **sql** → In tooling.lua (parsers, pg_format, sqlfluff)
- ✅ **toml** → In tooling.lua (taplo)
- ✅ **typescript** → In tooling.lua (vtsls, biome, eslint)
- ✅ **yaml** → In tooling.lua (yamlls with SchemaStore)

### Formatting & Linting (All Migrated)
- ✅ **biome** → In tooling.lua (LSP + formatter)
- ✅ **prettier** → In tooling.lua (prettierd)
- ✅ **eslint** → In tooling.lua (LSP)

### Core Plugins (All Migrated or Replaced)
- ✅ **copilot** → Present in new config
- ✅ **auto-session** → Present in new config
- ✅ **blink.cmp** → Present in new config (enhanced setup)
- ✅ **guess-indent** → Present in new config
- ✅ **hardtime** → Present in new config
- ✅ **helpview** → Present in new config
- ✅ **hlsearch** → Present in new config
- ✅ **lualine** → Present in new config (with custom cache)
- ✅ **noice** → Present in new config
- ✅ **numb** → Present in new config
- ✅ **nvim-surround** → Present in new config
- ✅ **opencode** → Present in new config
- ✅ **quicker** → Present in new config
- ✅ **rainbow-delimiters** → Present in new config
- ✅ **smart-splits** → Present in new config
- ✅ **ultimate-autopair** → Present in new config
- ✅ **mini.splitjoin** → Present in new config
- ✅ **treesitter-endwise** → Present in new config
- ✅ **auto-dark-mode** → Present in new config
- ✅ **catppuccin** → Present in new config

### New Features in New Config (Not in Old)
These are improvements/additions, not missing functionality:
- ✨ **grapple.nvim** (replaces harpoon2)
- ✨ **flash.nvim** (motion navigation)
- ✨ **which-key.nvim** (keymap hints)
- ✨ **render-markdown.nvim** (markdown rendering)
- ✨ **colorizer** (hex color highlighting)
- ✨ **wildfire.nvim** (text object selection)
- ✨ **ts-autotag** (HTML/JSX auto-closing)
- ✨ **gitsigns** (git integration)
- ✨ **no-neck-pain** (centering)
- ✨ **nvim-spectre** (find & replace)
- ✨ **lazydev** (Lua development)
- ✨ **conform.nvim** (formatting)
- ✨ **mason integration** (LSP/tool management)

---

## Summary

### Truly Missing (Need Decision)
1. **codecompanion.nvim** - Different AI tool in new config (opencode)
2. **tabout.nvim** - Insert mode context exit
3. **mini-hipatterns** - Pattern highlighting (partial: colorizer exists)
4. **DOT language support** - GraphViz

### Present but Disabled (Easy to Enable)
5. **vim-matchup** - Commented out in experimental.lua
6. **vimade** - Commented out in experimental.lua

### Intentionally Not Migrated
7. **pseint.vim** - Marked as temporary in old config

---

## Notes

- The new configuration has a more structured approach with module-based organization
- Language support is centralized in `modules/extras/tooling.lua` with comprehensive coverage
- Some plugins were replaced with modern alternatives (ts-comments vs mini-comment)
- The experimental.lua file contains disabled plugins that can be easily re-enabled
- Most LazyVim extras functionality has been successfully migrated or improved upon
