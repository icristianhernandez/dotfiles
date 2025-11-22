# Missing Features from nvim-old Configuration

This document tracks functionalities present in the old Neovim configuration (`nvim-old/`) that are missing or significantly different in the new configuration (`nvim/`).

## Summary

The new configuration has largely achieved feature parity with the old configuration, with several improvements and refactorings. However, there are some specific plugins and features that were present in the old config but are not in the new one.

---

## Missing Plugins

### 1. **harpoon** (File Bookmarking)
- **Old config**: `nvim-old/lua/modules/editor.lua` (lines 203-240)
- **New config**: Replaced with **grapple.nvim**
- **Status**: ✅ **Feature parity achieved** - grapple provides similar file tagging/bookmarking functionality
- **Note**: Different plugin with similar functionality (keybindings maintained: `<leader>H`, `<leader>h`, `<leader>1-9`)

### 2. **trouble.nvim** (Diagnostics Management)
- **Old config**: `nvim-old/lua/modules/editor.lua` (lines 393-435)
- **New config**: ❌ **Missing**
- **Impact**: Unified diagnostics viewer and quickfix integration is not available
- **Features lost**:
  - Consolidated diagnostics view (`<leader>xx`, `<leader>xX`)
  - Enhanced quickfix navigation with `[q` and `]q`
  - Workspace and buffer-level diagnostic views

### 3. **vim-matchup** (Enhanced Matching)
- **Old config**: `nvim-old/lua/modules/ui.lua` (lines 212-243)
- **New config**: ❌ **Missing**
- **Impact**: Enhanced `%` matching and surrounding-aware highlighting unavailable
- **Features lost**:
  - Offscreen match display via popup
  - `<leader>ci` keymap to highlight surrounding pairs
  - Treesitter integration for better matching
  - Manual surround highlighting toggle (`<leader>uH`)

### 4. **smear-cursor.nvim** (Cursor Animation)
- **Old config**: `nvim-old/lua/modules/ui.lua` (lines 156-164)
- **New config**: ❌ **Missing** (commented out in experimental)
- **Impact**: Cursor motion feedback/animation is disabled
- **Note**: Present but commented out in `nvim/lua/modules/experimental.lua` (lines 11-19)

### 5. **nvim-lint** (Linting)
- **Old config**: `nvim-old/lua/modules/tooling.lua` (lines 138-198)
- **New config**: ❌ **Missing**
- **Impact**: Dedicated linting via nvim-lint is not configured
- **Replacement**: Using **none-ls.nvim** for linting instead
- **Status**: ⚠️ **Different approach** - functionality may be covered by none-ls but with different implementation

### 7. **sidekick.nvim** (AI Edit Suggestions)
- **Old config**: `nvim-old/lua/modules/ai.lua` (lines 18-32)
- **New config**: ❌ **Missing**
- **Impact**: Jump/apply edit suggestions functionality is not available
- **Features lost**:
  - `<C-r>` keymap for jumping to or applying next edit suggestion
  - AI-assisted code editing workflow
- **Note**: This was a folke plugin that may have been experimental or discontinued

### 8. **Copilot Keymap Change**
- **Old**: `<C-r>` to accept copilot suggestions
- **New**: `<C-e>` to accept copilot suggestions
- **Status**: ⚠️ **Keymap changed**
- **Note**: New config also sets `auto_trigger = false` and `filetypes = { ["*"] = true }`

### 9. **Opencode.nvim Configuration**
- **Old**: Simpler configuration with basic keymaps
- **New**: Enhanced with custom contexts and prompts
- **Status**: ✅ **Enhanced**
- **Improvements**:
  - Added `@staged_diff` custom context
  - Added `commit_from_unstaged` and `commit_from_staged` prompts
  - Changed keymaps: `<C-x>` → `<leader>ap`, `ga` → `<leader>ao`, `<S-C-u>` → `<leader>au`, `<S-C-d>` → `<leader>ad`
- **Old config**: `nvim-old/lua/modules/tooling.lua` (lines 64-72)
- **New config**: ❌ **Missing**
- **Impact**: Automatic tool installation on startup is not configured
- **Replacement**: Manual installation via **mason-null-ls.nvim**

### 7. **vimade** (Window Dimming) - Configuration Difference
- **Old config**: Toggle mapping via Snacks (`<leader>uv`)
- **New config**: Present in `experimental.lua` but without toggle mapping
- **Status**: ⚠️ **Partial** - Plugin present but missing keybinding for toggle

---

## Plugin Differences (Replacements or Refactored)

### 1. **Completion Engine**
- **Old**: `blink.cmp` - basic configuration
- **New**: `blink.cmp` with **colorful-menu.nvim** integration
- **Status**: ✅ **Enhanced** - New config has better visual presentation

### 2. **File Bookmarking**
- **Old**: `harpoon` (branch harpoon2)
- **New**: `grapple.nvim`
- **Status**: ✅ **Replaced** - Similar functionality with different implementation

### 3. **Linting Approach**
- **Old**: Dedicated `nvim-lint` with debounced autocmds
- **New**: `none-ls.nvim` integrated linting
- **Status**: ⚠️ **Different approach** - Verify coverage

### 4. **Treesitter Management**
- **Old**: Direct `nvim-treesitter` configuration
- **New**: Using `treesitter-modules.nvim` wrapper
- **Status**: ✅ **Refactored** - Cleaner module-based approach

### 5. **Session Keys**
- **Old**: `<leader>fs` and `<leader>fS` for session management
- **New**: `<leader>ss` and `<leader>sS` for session management
- **Status**: ⚠️ **Keymap change** - Different keybindings for same functionality

---

## New Plugins (Not in Old Config)

These are improvements/additions in the new config:

1. **colorful-menu.nvim** - Enhanced completion menu colors
2. **copilot-lualine** - Copilot status in statusline
3. **grapple.nvim** - Replaces harpoon
4. **no-neck-pain.nvim** - Center text area
5. **nvim-spectre** - Project-wide find & replace
6. **wildfire.nvim** - Text object selection
7. **treesitter-modules.nvim** - Better treesitter config management
8. **none-ls.nvim** - Replaces dedicated linting setup
9. **mason-null-ls.nvim** - Better null-ls integration

---

## Core Configuration Differences

### 1. **Cursor Configuration**
- **Old**: `vim.opt.guicursor = "i-ci:ver25-blinkwait250-blinkon500-blinkoff450,r-cr-o:hor20"`
- **New**: `vim.opt.guicursor = "i-ci-c-t:ver25-blinkwait250-blinkon500-blinkoff450,r-cr-o:hor20"`
- **Status**: ✅ **Enhanced** - Added command and terminal mode cursor shapes

### 2. **Completion Options**
- **Old**: Not explicitly set
- **New**: `vim.opt.completeopt:append({ "menuone", "noselect", "popup" })`
- **Status**: ✅ **Enhanced** - Better completion menu behavior

### 3. **Update Time**
- **Old**: `vim.opt.updatetime = 160`
- **New**: `vim.opt.updatetime = 100`
- **Status**: ✅ **Improved** - Faster event updates

### 4. **Help Window Behavior**
- **Old**: Used `BufWinEnter` autocmd with conditional check
- **New**: Uses `FileType` autocmd for help files
- **Status**: ✅ **Cleaner** - More direct approach

### 5. **Cursorline Behavior**
- **Old**: Always enabled in options
- **New**: Dynamic - enabled only in active windows via autocmds
- **Status**: ✅ **Enhanced** - Better visual feedback for active window

### 6. **Dotenv File Type**
- **Old**: Not configured
- **New**: Automatic filetype detection for `.env` files
- **Status**: ✅ **New feature**

### 7. **Last Location Restore**
- **Old**: Simple implementation with basic exclusions
- **New**: Enhanced with more comprehensive exclusions (COMMIT_EDITMSG, MERGE_MSG, etc.)
- **Status**: ✅ **Improved**

---

## Module Configuration Differences

### 1. **Snacks.nvim Configuration**
- **Old**: Separate module `nvim-old/lua/modules/snacks.lua` with extensive picker/terminal config
- **New**: Integrated into `editor.lua` with enhanced features
- **Status**: ✅ **Refactored and enhanced**

### 2. **Tooling Centralization**
- **Old**: Separate stacks for LSP, formatters, linters in `extras/tooling.lua`
- **New**: More structured approach with clearer separation
- **Status**: ✅ **Better organization**

### 3. **Flash.nvim Keybindings**
- **Old**: `S` for treesitter (line 26)
- **New**: `S` for treesitter_search (line 777)
- **Status**: ⚠️ **Minor difference** in flash modes

### 4. **Mini.files Configuration**
- **Old**: Has custom extras/files.lua helper
- **New**: Inline autocmd configuration
- **Status**: ✅ **Simplified**

### 5. **Gitsigns Keybindings and on_attach**
- **Old**: Extensive `on_attach` function with comprehensive keymaps for hunk operations
- **New**: ❌ **Missing** - No `on_attach` function, only sign configuration
- **Status**: ❌ **Critical Missing Feature**
- **Features lost**:
  - Hunk navigation: `]h`, `[h`, `]H`, `[H`
  - Hunk operations: `<leader>ghs` (stage), `<leader>ghr` (reset)
  - Buffer operations: `<leader>ghS` (stage buffer), `<leader>ghR` (reset buffer)
  - Undo staging: `<leader>ghu`
  - Preview and blame: `<leader>ghp`, `<leader>ghb`, `<leader>ghB`
  - Diff operations: `<leader>ghd`, `<leader>ghD`
  - Text object: `ih` (select hunk)

---

## Recommendations

1. **High Priority**:
   - Add **trouble.nvim** back to the new config for better diagnostics management
   - Consider re-enabling **vim-matchup** for enhanced % matching if needed
   - Verify **gitsigns** keybindings are properly configured

2. **Medium Priority**:
   - Review **nvim-lint** vs **none-ls** linting coverage
   - Add toggle keymap for **vimade** (`<leader>uv`)
   - Consider adding **mason-tool-installer** for auto-installation

3. **Low Priority**:
   - Evaluate if **smear-cursor** animation is desired
   - Document keymap changes (session keys: `<leader>fs` → `<leader>ss`)

---

## Notes

- The new configuration follows a more modular approach with better separation of concerns
- Several features have been refactored or replaced with alternatives
- Overall, the new config is cleaner and more maintainable while maintaining most functionality
- The use of `snacks.nvim` picker has been significantly expanded in the new config
