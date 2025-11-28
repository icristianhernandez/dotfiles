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

## LazyVim Core Features Analysis

The following LazyVim core plugins are intentionally replaced or not needed:

### Replaced with Modern Alternatives
- **nvim-cmp** → ✅ Replaced with `blink.cmp` (faster, more modern)
- **LuaSnip** → ✅ Blink uses built-in snippets + `friendly-snippets`
- **Telescope** → ✅ Replaced with `snacks.picker` (integrated experience)
- **neo-tree** → ✅ Replaced with `mini.files` (lighter, faster)
- **bufferline** → ✅ Intentionally disabled (uses tabs in lualine instead)
- **persistence** → ✅ Replaced with `auto-session` (better branch support)

### Not Used in Old Config
- **trouble.nvim** → Not used (only `vim.g.trouble_lualine = false` found)
- **todo-comments** → Not found in old config
- **dressing.nvim** → Not found in old config

### Mini.nvim Modules
The new config uses individual mini.* modules rather than the full mini.nvim bundle:
- `mini.files`, `mini.move`, `mini.splitjoin`, `mini.icons` are all present

---

## Summary

### Truly Missing (Need Decision)
1. **codecompanion.nvim** - AI chat interface (replaced with opencode, different capabilities)
2. **tabout.nvim** - Insert mode context exit functionality (`<C-x>` to exit brackets/quotes)
3. **mini-hipatterns** - Pattern highlighting (partial coverage with `colorizer` for hex colors)
4. **DOT language support** - GraphViz DOT language (parsers and LSP)
5. **Deno LSP** - `denols` server not configured (old config had deno support with proper root detection)
6. **Custom Biome root_dir** - Old config had sophisticated biome.json detection logic
7. **Custom nixd settings** - Old config had specific NixOS/Home Manager option expressions

### Present but Disabled (Easy to Enable)
5. **vim-matchup** - Enhanced % matching (commented out in experimental.lua)
6. **vimade** - Inactive window dimming (commented out in experimental.lua)

### Intentionally Not Migrated
7. **pseint.vim** - Marked as temporary in old config

---

## LSP Configuration Differences

### Deno Support
**Old Config:**
```lua
denols = {
    root_dir = function(fname)
        return lsp_util.root_pattern("deno.json", "deno.jsonc", "deno.lock")(fname)
    end,
},
ts_ls = {
    root_dir = function(fname)
        if lsp_util.root_pattern("deno.json", "deno.jsonc", "deno.lock")(fname) then
            return nil  -- Disable ts_ls in Deno projects
        else
            return lsp_util.root_pattern("package.json")(fname)
        end
    end,
    single_file_support = false,
},
```
**New Config:** Uses `vtsls` instead of `ts_ls`, but no deno support or deno/typescript conflict resolution.

### Biome Root Directory Detection
**Old Config:**
```lua
biome = {
    root_dir = function(fname)
        local root_files = { "biome.json", "biome.jsonc" }
        local biome_package_config_files = lsp_util.insert_package_json(root_files, "biome", fname)
        local found_root = lsp_util.root_pattern(unpack(biome_package_config_files))(fname)
        if found_root then
            return found_root
        end
        local biome_dependency_root = lsp_util.insert_package_json({}, "@biomejs/biome", fname)
        return lsp_util.root_pattern(unpack(biome_dependency_root))(fname)
    end,
},
```
**New Config:** Biome is in the LSP list but uses default root detection (may not work for all project structures).

### NixD Configuration
**Old Config:**
```lua
nixd = {
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }",
            },
            formatting = {
                command = { "nixfmt" },
            },
            options = {
                nixos = {
                    expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nixos.options",
                },
                ["home-manager"] = {
                    expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nixos.options.home-manager.users.type.getSubOptions []",
                },
            },
        },
    },
    root_dir = function(fname)
        return lsp_util.root_pattern("flake.nix", "flake.lock", "default.nix", "shell.nix", ".git")(fname)
    end,
},
```
**New Config:** Has nixd in tooling but without the custom settings for NixOS/Home Manager completions.

### PSeInt LSP
**Old Config:**
```lua
vim.lsp.config("pseint-lsp", {
    cmd = { "/home/crisarch/pseint-lsp/.venv/bin/pseint-lsp" },
    filetypes = { "pseint" },
    root_markers = { ".git", "proyecto.psc" },
    name = "pseint-lsp",
})
vim.lsp.enable("pseint-lsp")
```
**New Config:** Not present (was temporary).

### Diagnostic Configuration
**Old Config:**
```lua
diagnostics = {
    virtual_text = false,
    signs = {
        text = { [ERROR] = "", [WARN] = "", [INFO] = "", [HINT] = "" },
        numhl = { [WARN] = "WarningMsg", [ERROR] = "ErrorMsg", ... },
    },
},
```
**New Config:** Uses mini.icons for diagnostic signs (more automated setup).

---

## Functional Differences

### CodeCompanion vs OpenCode
- **Old (CodeCompanion):** Full-featured AI chat interface with actions, inline suggestions
- **New (OpenCode):** Focused on context-based prompts, git commit assistance
- **Impact:** Different workflow for AI assistance (more specialized in new config)

### Missing Tabout
- **Feature:** Quick exit from brackets/quotes/tags in insert mode
- **Old Keybinds:** `<C-x>` (forward), `<C-z>` (backward)
- **Impact:** Less convenient bracket/quote navigation

---

## Notes

### Architecture Improvements
- The new configuration has a more structured approach with module-based organization
- Language support is centralized in `modules/extras/tooling.lua` with comprehensive coverage
- Plugin loading is more intentional and performant
- Better separation of concerns (ai.lua, coding.lua, editor.lua, ui.lua, tooling.lua)

### Migration Quality
- ✅ All 9 language extras successfully migrated with modern tooling
- ✅ All formatters and linters present
- ✅ Core editing features maintained or improved
- ✅ All autocmds and key LazyVim features replicated (cursor restore, auto-resize, etc.)
- ✅ Modern alternatives adopted (ts-comments, grapple, blink.cmp)

### Experimental Features
The experimental.lua file contains commented-out plugins that were tested but not currently enabled:
- `vim-matchup`, `vimade`, `no-neck-pain`, `nvim-spectre`
These can be easily re-enabled by uncommenting if needed.
