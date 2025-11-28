# Missing Features from nvim-old Configuration

This document tracks functionalities present in the old Neovim configuration (`nvim-old/`) that are missing or significantly different in the new configuration (`nvim/`).

**Last Updated**: 2025-11-22  
**Analysis Version**: Initial comprehensive comparison

### Configuration Statistics

| Metric | Old Config | New Config | Change |
|--------|-----------|-----------|--------|
| Total Plugins | 52 | 56 | +4 (+7.7%) |
| Lua Files | 17 | 16 | -1 |
| Module Files | 11 | 10 | -1 (consolidated) |
| Core Files | 6 | 7 | +1 (os.lua added) |

---

## Executive Summary

### Overall Assessment: ⚠️ **Near Feature Parity with Critical Gaps**

The new configuration is well-architected with improvements in modularity, organization, and several enhanced features. However, there are **2 critical missing features** and several noteworthy changes that need attention:

**Critical Issues (Blocking):**
- ❌ **Gitsigns keybindings completely missing** - No git hunk operations available
- ❌ **trouble.nvim missing** - No unified diagnostics viewer

**High Priority Issues:**
- ⚠️ Different linting approach (nvim-lint → none-ls) - needs verification
- ⚠️ vim-matchup missing - enhanced % matching unavailable
- ⚠️ sidekick.nvim missing - AI edit suggestions lost

**Positive Changes:**
- ✅ Better organized tooling system with comprehensive stacks
- ✅ Enhanced completion with colorful-menu integration
- ✅ Improved core configurations (cursor, completion options, updatetime)
- ✅ Dynamic cursorline and better autocmds
- ✅ New useful plugins (grapple, no-neck-pain, nvim-spectre, wildfire)

---

## Summary

The new configuration has largely achieved feature parity with the old configuration, with several improvements and refactorings. However, there are some specific plugins and features that were present in the old config but are not in the new one.

**Important Note**: Despite the task description mentioning LazyVim, the old configuration does NOT use LazyVim as a Neovim distribution. Both configurations use **lazy.nvim** (the plugin manager by folke) but not LazyVim (the full Neovim distribution). The only LazyVim references in the old config are:
- Comments referencing LazyVim clipboard handling
- A buffer variable `vim.b[buf].lazyvim_last_loc` used for cursor position restoration (likely borrowed naming convention)

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

### **Critical (Must Address)**:
1. ❌ **Add trouble.nvim** back to the new config for better diagnostics management
   - Provides unified diagnostics viewer
   - Enhanced quickfix navigation
   - Essential for developer workflow
   
2. ❌ **Add gitsigns on_attach function** with all keybindings
   - Critical for git workflow: hunk navigation, staging, previewing, blame
   - Missing 15+ essential keybindings for git operations
   
3. ⚠️ **Verify none-ls vs nvim-lint** coverage
   - Ensure all linting functionality is properly covered by none-ls
   - Old config had dedicated nvim-lint with debouncing

### **High Priority (Should Address)**:
1. ⚠️ **Consider re-enabling vim-matchup** for enhanced % matching if needed by workflow
   - Better matching for brackets, tags, and treesitter nodes
   - Offscreen match display
   
2. ⚠️ **Add toggle keymap for vimade** (`<leader>uv`)
   - Plugin is present but missing keybinding
   
3. ⚠️ **Review sidekick.nvim removal**
   - AI edit suggestions may have been valuable
   - Consider if this functionality is needed

### **Medium Priority (Good to Have)**:
1. 📝 **Document keymap changes** for users migrating from old config:
   - Session keys: `<leader>fs`/`<leader>fS` → `<leader>ss`/`<leader>sS`
   - Copilot accept: `<C-r>` → `<C-e>`
   - Opencode actions: Multiple keymap changes documented above
   
2. 📝 **Consider adding mason-tool-installer** for convenience
   - Auto-installation on startup was convenient
   - Currently manual via mason-null-ls

### **Low Priority (Optional)**:
1. 💡 **Evaluate smear-cursor** animation
   - Currently commented out in experimental
   - May provide nice visual feedback
   
2. 💡 **Review colorscheme differences**
   - Old: `dim_inactive` option (disabled)
   - New: `show_end_of_buffer`, `term_colors`, float options

---

## Migration Checklist for Users

If migrating from old to new config, be aware of:

- [ ] Learn new keybindings (see "Document keymap changes" above)
- [ ] Verify git workflow with gitsigns (missing keybindings)
- [ ] Check if trouble.nvim is needed for your diagnostic workflow
- [ ] Confirm linting works as expected (different approach)
- [ ] Test session management with new keybindings
- [ ] Verify all LSP servers, formatters, and linters are installed
- [ ] Check if vim-matchup features are missed

---

## Analysis Methodology

This comparison was conducted through:

1. **Repository Structure Analysis**: Identified nvim-old/ as deprecated config and nvim/ as new config
2. **Plugin Inventory**: Compared lazy-lock.json files to identify added, removed, and shared plugins
3. **Module-by-Module Comparison**: Analyzed each configuration module:
   - Core: options, keymaps, autocmds
   - Plugins: editor, ui, coding, tooling, ai, colorscheme
   - Extras: tooling stacks, helper modules
4. **Configuration Diffing**: Used diff tools to identify specific changes in behavior
5. **Feature Impact Assessment**: Evaluated the impact of each missing or changed feature

### Files Analyzed

**Old Configuration (nvim-old/):**
- `init.lua`, `lazy-lock.json`
- Core: `options.lua`, `keymaps.lua`, `autocmds.lua`, `lazy-setup.lua`, `neovide.lua`, `wsl.lua`
- Modules: `ai.lua`, `cmp.lua`, `coding.lua`, `colorscheme.lua`, `editor.lua`, `snacks.lua`, `tooling.lua`, `treesitter.lua`, `ui.lua`
- Extras: `tooling.lua`, `files.lua`

**New Configuration (nvim/):**
- `init.lua`, `lazy-lock.json`
- Core: `core/options.lua`, `core/keymaps.lua`, `core/autocmds.lua`, `core/lazy-setup.lua`, `core/neovide.lua`, `core/wsl.lua`, `core/os.lua`
- Modules: `modules/ai.lua`, `modules/coding.lua`, `modules/colorscheme.lua`, `modules/editor.lua`, `modules/experimental.lua`, `modules/tooling.lua`, `modules/ui.lua`
- Extras: `modules/extras/tooling.lua`, `modules/extras/lualine_cache.lua`

### Key Findings Summary

**Plugins Only in Old Config (8):**
1. harpoon - Replaced with grapple.nvim
2. trouble.nvim - **Missing** ❌
3. vim-matchup - **Missing** ❌
4. smear-cursor.nvim - Commented out in experimental
5. nvim-lint - Replaced with none-ls
6. mason-tool-installer - Replaced with mason-null-ls
7. schemastore.nvim (lowercase) - Present as SchemaStore.nvim in new
8. treesitter (alias) - Present as nvim-treesitter in new

**Plugins Only in New Config (12):**
1. colorful-menu.nvim - Enhancement ✅
2. copilot-lualine - Enhancement ✅
3. grapple.nvim - Replacement for harpoon ✅
4. no-neck-pain.nvim - New feature ✅
5. nvim-spectre - New feature ✅
6. wildfire.nvim - New feature ✅
7. treesitter-modules.nvim - Better organization ✅
8. none-ls.nvim - Replacement for nvim-lint ⚠️
9. mason-null-ls.nvim - Replacement for mason-tool-installer ✅
10. plenary.nvim - Dependency ✅
11. SchemaStore.nvim (capitalized) - Same as old ✅
12. nvim-treesitter (explicit) - Same as old ✅

---

- The new configuration follows a more modular approach with better separation of concerns
- Several features have been refactored or replaced with alternatives
- Overall, the new config is cleaner and more maintainable while maintaining most functionality
- The use of `snacks.nvim` picker has been significantly expanded in the new config
