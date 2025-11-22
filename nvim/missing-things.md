# Missing Functionalities from Old Configuration

This document tracks functionalities present in `nvim-old/` that are missing or have been replaced in the new `nvim/` configuration.

## Summary

The new configuration has successfully migrated most functionalities from the old configuration. Several plugins have been replaced with more modern alternatives that provide similar or improved functionality.

## Missing Plugins

### 1. ❌ folke/trouble.nvim
**Status**: Missing  
**Location in old config**: `nvim-old/lua/modules/editor.lua:394`  
**Functionality**: Enhanced diagnostics and quickfix list UI with better navigation and filtering  
**Keybindings in old config**:
- `<leader>xx` - Toggle Trouble diagnostics
- `<leader>xX` - Toggle Trouble buffer diagnostics
- `[q` - Previous Trouble/Quickfix item (with fallback)
- `]q` - Next Trouble/Quickfix item (with fallback)

**Notes**: The old config uses Trouble for enhanced diagnostic viewing and quickfix navigation. The new config uses `stevearc/quicker.nvim` for quickfix enhancement but doesn't have a direct replacement for Trouble's diagnostic UI features.

---

### 2. ❌ folke/sidekick.nvim
**Status**: Missing  
**Location in old config**: `nvim-old/lua/modules/ai.lua:18`  
**Functionality**: Enhanced edit suggestions with jump/apply functionality for AI-powered code edits  
**Keybindings in old config**:
- `<C-r>` in insert mode - Jump to or apply next edit suggestion

**Notes**: This plugin works in conjunction with Copilot to provide better edit suggestion navigation. The new config doesn't have this enhancement, relying only on basic Copilot functionality.

---

## Replaced/Refactored Plugins

### 1. ✅ ThePrimeagen/harpoon → cbochs/grapple.nvim
**Status**: Replaced with equivalent functionality  
**Old location**: `nvim-old/lua/modules/editor.lua:205`  
**New location**: `nvim/lua/modules/editor.lua:692`  
**Functionality**: Quick file bookmarking and navigation

**Keybinding changes**:
- Old: `<leader>H` (add), `<leader>h` (menu), `<leader>1-9` (select)
- New: `<leader>H` (toggle), `<leader>h` (menu), `<leader>1-9` (select)

**Notes**: Both plugins provide similar file bookmark functionality. Grapple is a more actively maintained alternative to Harpoon.

---

### 2. ✅ mfussenegger/nvim-lint → nvimtools/none-ls.nvim
**Status**: Replaced with different approach  
**Old location**: `nvim-old/lua/modules/tooling.lua:140`  
**New location**: `nvim/lua/modules/tooling.lua:152`  
**Functionality**: Code linting with configurable linters per filetype

**Approach changes**:
- Old: Used nvim-lint with per-filetype linter configuration and debounced auto-linting
- New: Uses none-ls (null-ls fork) with mason-null-ls for automatic installation

**Keybinding changes**:
- Old: `<leader>cl` - Manual lint trigger
- New: No manual lint trigger keybinding (linting is automatic via none-ls)

**Notes**: The new approach integrates linting through the LSP protocol via none-ls, which provides a more unified experience with LSP diagnostics.

---

### 3. ✅ WhoIsSethDaniel/mason-tool-installer.nvim → mason-null-ls integration
**Status**: Functionality replaced  
**Old location**: `nvim-old/lua/modules/tooling.lua:65`  
**New approach**: Uses `jay-babu/mason-null-ls.nvim` (at `nvim/lua/modules/tooling.lua:112`)

**Functionality**: Automatic installation of external tools (formatters, linters, debuggers)

**Notes**: The old config used mason-tool-installer for automatic tool installation. The new config uses mason-null-ls which provides more integrated tool management specifically for none-ls sources.

---

### 4. ✅ Separate cmp.lua module → Integrated into editor.lua
**Status**: Refactored/merged  
**Old location**: `nvim-old/lua/modules/cmp.lua`  
**New location**: `nvim/lua/modules/editor.lua:108`

**Functionality**: Completion engine configuration (blink.cmp)

**Notable changes**:
- Old: `<C-e>` to show/hide completion menu
- New: `<C-d>` to show/hide completion menu, `<C-e>` for accepting Copilot suggestions
- New config includes additional features like colorful-menu.nvim integration
- Signature help configuration differs slightly

**Notes**: The blink.cmp configuration is largely similar but has been integrated into the editor module for better organization.

---

### 5. ✅ Separate snacks.lua module → Integrated into editor.lua and ui.lua
**Status**: Refactored/merged  
**Old location**: `nvim-old/lua/modules/snacks.lua`  
**New location**: `nvim/lua/modules/editor.lua:229` and `nvim/lua/modules/ui.lua:82`

**Functionality**: Small utilities (picker, terminal, scratch, notifications, etc.)

**Notable changes**:
- Snacks configuration is now split between editor.lua (picker, terminal, scratch) and ui.lua (scroll, notifier)
- New config adds more picker sources (git_branches, git_log, git_log_line, git_log_file)
- New config uses "sidebar" layout instead of "vertical" layout for picker
- Scratch root is explicitly set to `~/dotfiles/notes` in new config

**Keybinding additions in new config**:
- `<leader>gx` - Git browse
- `<leader>gb` - Git branches
- `<leader>gl` - Git log
- `<leader>gL` - Git log line
- `<leader>gf` - Git log file
- `<leader>sc` - Search (additional)
- `<leader>sf` - Search (additional)
- `<leader>sp` - Search (additional)
- `<leader>sr` - Search (additional)
- `<leader>sw` - Grep word/visual selection

**Notes**: The new config enhances Snacks with more features and better organization across modules.

---

### 6. ✅ Separate treesitter.lua module → Integrated into tooling.lua
**Status**: Refactored/merged  
**Old location**: `nvim-old/lua/modules/treesitter.lua`  
**New location**: `nvim/lua/modules/tooling.lua:5`

**Functionality**: Treesitter configuration for syntax highlighting and AST-based features

**Notable changes**:
- Old: Used nvim-treesitter directly with incremental selection keymaps (`<CR>` and `<BS>`)
- New: Uses MeanderingProgrammer/treesitter-modules.nvim wrapper
- New: Incremental selection is commented out, replaced by wildfire.nvim (at `nvim/lua/modules/tooling.lua:23`)
- New: treesitter-context configuration is identical in both

**Notes**: The new config uses a more modular approach with treesitter-modules.nvim and adds wildfire.nvim for smart selection. The core functionality remains the same.

---

## Additional New Features in New Config

The following plugins/features are present in the new config but not in the old:

1. **AndreM222/copilot-lualine** - Copilot status in lualine
2. **MeanderingProgrammer/treesitter-modules.nvim** - Modular treesitter configuration
3. **sustech-data/wildfire.nvim** - Smart text object selection (replaces treesitter incremental selection)
4. **xzbdmw/colorful-menu.nvim** - Enhanced completion menu with colors
5. **shortcuts/no-neck-pain.nvim** - Center buffer for focused editing (in experimental.lua)
6. **nvim-pack/nvim-spectre** - Search and replace across project
7. **cbochs/grapple.nvim** - File bookmarking (harpoon replacement)

---

## Configuration File Structure Changes

### Old Config Structure:
```
nvim-old/lua/
├── modules/
│   ├── ai.lua
│   ├── cmp.lua          ← Separate completion module
│   ├── coding.lua
│   ├── colorscheme.lua
│   ├── editor.lua
│   ├── snacks.lua       ← Separate snacks module
│   ├── tooling.lua
│   ├── treesitter.lua   ← Separate treesitter module
│   └── ui.lua
├── autocmds.lua
├── keymaps.lua
├── lazy-setup.lua
└── options.lua
```

### New Config Structure:
```
nvim/lua/
├── core/               ← Core files in subdirectory
│   ├── autocmds.lua
│   ├── keymaps.lua
│   ├── lazy-setup.lua
│   ├── neovide.lua
│   ├── options.lua
│   ├── os.lua         ← New OS detection module
│   └── wsl.lua
├── modules/
│   ├── ai.lua
│   ├── coding.lua
│   ├── colorscheme.lua
│   ├── editor.lua     ← Now includes cmp, snacks config
│   ├── experimental.lua ← New experimental features
│   ├── tooling.lua    ← Now includes treesitter
│   └── ui.lua         ← Now includes snacks notifier config
└── spec/              ← New test directory
    └── tooling_spec.lua
```

**Notes**: The new config has better organization with core files in a subdirectory and more consolidated module structure.

---

## Options and Settings Differences

### Options (options.lua)
**Differences identified**:
1. **guicursor**: 
   - Old: `"i-ci:ver25-blinkwait250-blinkon500-blinkoff450,r-cr-o:hor20"`
   - New: `"i-ci-c-t:ver25-blinkwait250-blinkon500-blinkoff450,r-cr-o:hor20"` (added `-c-t` modes)

2. **completeopt**:
   - Old: Not set
   - New: Appends `{ "menuone", "noselect", "popup" }`

3. **showtabline**:
   - Old: `vim.opt.showtabline = 1`
   - New: `vim.o.showtabline = 1` (uses `vim.o` instead of `vim.opt`)

4. **updatetime**:
   - Old: `160` ms
   - New: `100` ms

**Notes**: These are minor refinements that don't significantly change functionality.

### Keymaps (keymaps.lua)
**Differences identified**:
1. **cmd_delete_word() function**:
   - Old: Returns `"<C-w>"` string
   - New: Uses `vim.api.nvim_replace_termcodes()` and `vim.api.nvim_feedkeys()` for more proper key feeding

**Notes**: The new implementation is more correct but functionally equivalent.

### Autocmds
Not compared in detail yet - both configs have custom autocmds that would need individual review.

---

## Recommendations

### High Priority (Missing Important Functionality)
1. **Consider adding folke/trouble.nvim** - Provides significantly better diagnostic viewing and navigation compared to just using quickfix lists. The UI is highly useful for working with LSP diagnostics.

2. **Consider adding folke/sidekick.nvim** - Enhances Copilot workflow with better edit suggestion navigation. If AI-assisted coding is important, this is a valuable addition.

### Medium Priority (Quality of Life)
None identified - most QoL features have been successfully migrated or improved.

### Low Priority (Already Adequately Replaced)
1. mason-tool-installer.nvim - The new mason-null-ls approach is sufficient
2. nvim-lint - none-ls provides equivalent functionality through LSP protocol
3. harpoon - grapple provides equivalent file bookmarking

---

## Conclusion

The new configuration is a well-executed refactor that:
- ✅ Maintains all core functionality
- ✅ Improves code organization (core/ subdirectory, consolidated modules)
- ✅ Upgrades several plugins to more modern alternatives
- ✅ Adds new useful features (wildfire, spectre, no-neck-pain, colorful-menu)
- ❌ Missing 2 plugins that provided unique value (trouble.nvim, sidekick.nvim)

The only significant gaps are **trouble.nvim** and **sidekick.nvim**, which provided features not fully replicated in the new configuration.
