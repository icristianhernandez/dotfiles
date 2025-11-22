# Missing Features from Old Configuration

This document tracks functionalities present in the old Neovim configuration (`nvim-old/`) that have not yet been migrated to the new configuration (`nvim/`).

> **Note**: This list excludes improvements, refactors, or new features in the new setup. Only missing functionalities from the old configuration are documented here.

## Table of Contents

- [Plugins Missing from New Configuration](#plugins-missing-from-new-configuration)
- [Missing Keybindings](#missing-keybindings)
- [LazyVim-Specific Features](#lazyvim-specific-features)
- [New Features in New Configuration](#new-features-in-new-configuration-not-in-old)
- [Summary](#summary)
- [Next Steps](#next-steps)
- [Final Assessment](#final-assessment)

---

## Plugins Missing from New Configuration

### Editor/Navigation Plugins

#### 1. **ThePrimeagen/harpoon** (branch: harpoon2)
- **Status**: Missing - Replaced by `cbochs/grapple.nvim`
- **Functionality**: Quick file bookmarking and navigation
- **Old Config Location**: `nvim-old/lua/modules/editor.lua` (lines 203-240)
- **Features**:
  - Add files to harpoon list
  - Quick menu to view/select harpooned files
  - Numeric keybindings (leader+1 through leader+9) to jump to files
- **New Alternative**: Grapple provides similar functionality with `scope = "git_branch"`

#### 2. **folke/trouble.nvim**
- **Status**: Missing
- **Functionality**: Pretty list for diagnostics, references, quickfix, and location lists
- **Old Config Location**: `nvim-old/lua/modules/editor.lua` (lines 393-435)
- **Features**:
  - Toggle diagnostics window with `<leader>xx`
  - Buffer diagnostics with `<leader>xX`
  - LSP mode with right-side positioning
  - Integration with quickfix navigation (`]q`, `[q`)
- **Impact**: No replacement found in new config - diagnostics viewing is less feature-rich

### Development Tools

#### 3. **mfussenegger/nvim-lint**
- **Status**: Replaced by none-ls.nvim (null-ls)
- **Functionality**: Asynchronous linting engine
- **Old Config Location**: `nvim-old/lua/modules/tooling.lua` (lines 138-198)
- **Old Features**:
  - Linters by filetype configuration
  - Debounced linting on BufReadPost, BufWritePost, InsertLeave (300ms)
  - Manual lint trigger with `<leader>cl`
  - Per-linter configuration and conditions
  - Supported linters: eslint_d (JS/TS), markdownlint-cli2, shellcheck, fish, statix, sqlfluff
- **New Alternative**: `nvimtools/none-ls.nvim` provides linting via builtins
  - Location: `nvim/lua/modules/tooling.lua` and `nvim/lua/modules/extras/tooling.lua`
  - Linters defined in tooling stacks: yamllint, markdownlint-cli2, jsonlint, statix, fish, shellcheck, sqlfluff, commitlint, gitlint, gitrebase
  - Integration via `mason-null-ls` for installation
  - Diagnostics provided via none-ls builtins
- **Key Difference**: 
  - Old: Dedicated nvim-lint with manual debouncing and autocmds
  - New: none-ls integrates linting with LSP diagnostics
  - Old: `<leader>cl` to manually lint
  - New: No manual lint trigger found (linting is automatic via LSP)
  - Old: eslint_d as linter
  - New: eslint as LSP server (improvement)
- **Impact**: Different linting architecture but similar functionality. Manual lint trigger missing (`<leader>cl`). Some linters handled differently (eslint via LSP instead of standalone linter).

#### 4. **WhoIsSethDaniel/mason-tool-installer.nvim**
- **Status**: Missing - Replaced by mason-null-ls
- **Functionality**: Auto-install mason tools (formatters, linters, debuggers)
- **Old Config Location**: `nvim-old/lua/modules/tooling.lua` (lines 64-72)
- **Features**:
  - Automatic installation of tools on startup
  - Configurable delay (3000ms)
  - Separate from LSP server installation
- **New Alternative**: `jay-babu/mason-null-ls.nvim` handles tool installation

### UI Plugins

#### 5. **folke/sidekick.nvim**
- **Status**: Missing
- **Functionality**: Edit suggestion navigation and application
- **Old Config Location**: `nvim-old/lua/modules/ai.lua` (lines 17-32)
- **Features**:
  - `<C-r>` binding to jump to or apply next edit suggestion
  - Integration with AI-powered editing workflows
- **Impact**: Navigation between AI edit suggestions not available

### Missing UI Features

#### 6. **Snacks.nvim Picker Layout Differences**
- **Old Config**: Uses `vertical` layout with custom min_height (line 20 in snacks.lua)
- **New Config**: Uses `sidebar` layout
- **Impact**: Different visual presentation of picker results

#### 7. **Mini.files Window Customization**
- **Old Config**: Custom window styling via `modules/extras/files.lua`
  - Rounded border
  - Title positioning
  - Dynamic height calculation with max_height=15
- **New Config**: Simplified window configuration
  - Fixed width settings (width_focus=35, width_preview=60)
  - Height set to 20% of screen via autocmd
  - Snacks.rename integration for file operations
- **Impact**: Different visual appearance and behavior

### Configuration Differences

#### 8. **Catppuccin Theme Settings**
- **Old Config**:
  - `flavour` dynamically set based on `vim.o.background`
  - `dim_inactive` configuration (disabled by default)
- **New Config**:
  - Missing `flavour` configuration
  - Added `show_end_of_buffer`, `term_colors`, `float.solid`
- **Impact**: Slightly different theme behavior

#### 9. **Blink.cmp Configuration Differences**
- **Old Module**: Dedicated `cmp.lua` file
- **New Location**: Integrated into `editor.lua`
- **Key Differences**:
  - **Old**: Auto-accept single item, uses `<C-e>` for show/hide
  - **New**: Manual selection required, uses `<C-d>` for show/hide, includes `colorful-menu.nvim`
  - **Old**: LazyDev integration with higher priority (score_offset=100)
  - **New**: Keyword filtering (removes Keyword kind items)
  - **Old**: `ghost_text = false`
  - **New**: `ghost_text = true`
- **Impact**: Different completion behavior and visual presentation

#### 10. **Treesitter Configuration**
- **Old Module**: Dedicated `treesitter.lua` file
- **New**: Split between `tooling.lua` and integrated configuration
- **Key Differences**:
  - **Old**: Uses `nvim-treesitter/nvim-treesitter` directly
  - **New**: Uses `MeanderingProgrammer/treesitter-modules.nvim` wrapper
  - **Old**: Incremental selection enabled with `<CR>` and `<bs>`
  - **New**: Incremental selection commented out
  - **Old**: Foldmethod/foldexpr commented out
- **Impact**: Incremental selection not available in new config

### LSP and Tooling

#### 11. **Auto-session Bypass Filetypes**
- **Old Config**: Includes `bypass_save_filetypes = { "alpha", "dashboard" }`
- **New Config**: Missing bypass_save_filetypes
- **Impact**: May save sessions for dashboard-type buffers

#### 12. **Session Keybinding Changes**
- **Old**: `<leader>fs` for search, `<leader>fS` for delete
- **New**: `<leader>ss` for search, `<leader>sS` for delete
- **Impact**: Different keybinding scheme (moved from "file" to "search" group)

### Experimental Features

#### 13. **Hardtime.nvim Configuration**
- **Old Location**: `coding.lua`
- **New Location**: `editor.lua`
- **Old Config**: Disables j/k/arrow restrictions
- **New Config**: Additionally disables mouse restriction
- **Impact**: Slightly more permissive in new config

#### 14. **Flash.nvim Mode Differences**
- **Old**: Uses `S` for `treesitter()`, `R` for `treesitter_search()`
- **New**: Uses `S` for `treesitter_search()`, `R` for `treesitter_search()`
- **New**: Adds rainbow label highlighting
- **Impact**: Different treesitter navigation behavior

### Missing Visual Features

#### 15. **sphamba/smear-cursor.nvim**
- **Status**: Commented out in `experimental.lua`
- **Functionality**: Cursor smear animation for motion feedback
- **Old Config Location**: `nvim-old/lua/modules/ui.lua` (lines 156-164)
- **New Config Location**: `nvim/lua/modules/experimental.lua` (lines 11-19, commented)
- **Features**:
  - Smooth cursor animation during motion
  - Conditional loading (disabled in Neovide)
  - `never_draw_over_target` and `hide_target_hack` options
- **Impact**: Visual feedback during cursor movement not available

#### 16. **andymass/vim-matchup**
- **Status**: Commented out in `experimental.lua`
- **Functionality**: Enhanced % matching and surrounding-aware highlighting
- **Old Config Location**: `nvim-old/lua/modules/ui.lua` (lines 212-243)
- **New Config Location**: `nvim/lua/modules/experimental.lua` (lines 112-133, commented)
- **Features**:
  - Offscreen matching pairs shown in popup
  - Treesitter integration
  - Snacks.toggle integration for hi_surround
  - `<leader>ci` to highlight surrounding pairs
  - Deferred rendering for performance
- **Impact**: Advanced bracket/delimiter matching not available

#### 17. **tadaa/vimade Location**
- **Status**: Moved to `experimental.lua`
- **Old Location**: `nvim-old/lua/modules/ui.lua`
- **New Location**: `nvim/lua/modules/experimental.lua` (lines 2-10)
- **Impact**: Still available but in experimental module (not missing)

### Auto-commands and Options

#### 18. **Enhanced Autocmds in New Config** (Improvements, not missing)
The new configuration includes several enhanced autocmds:
- **VimResized**: Auto-resize splits when terminal window is resized
- **Cursorline Management**: Show cursorline only in active focused windows
- **Dotenv Filetype**: Auto-detect `.env` files as `dosini` filetype
- **Enhanced Last Location**: More robust excluded filetypes and basenames

These are improvements, not missing features.

#### 19. **Options.lua Differences**
- **Old**: `vim.opt.updatetime = 160`
- **New**: `vim.opt.updatetime = 100`
- **Impact**: Faster event triggering in new config (improvement, not missing)

- **Old**: `vim.opt.guicursor` blink only in insert mode
- **New**: Blink in insert, command, and terminal modes (`i-ci-c-t`)
- **Impact**: More visible cursor in command/terminal modes (improvement, not missing)

- **New Only**: `vim.opt.completeopt:append({ "menuone", "noselect", "popup" })`
- **Impact**: Enhanced builtin completion behavior (improvement, not missing)

---

## Missing Keybindings

These keybindings existed in the old configuration but are not present in the new one:

1. **`<leader>cl`** - Manual lint trigger (nvim-lint)
   - Old: Manually trigger linting on current buffer
   - New: No equivalent (linting is automatic via none-ls/LSP)

2. **`<leader>xx`** - Toggle Trouble diagnostics window
   - Old: Open diagnostics in Trouble window
   - New: No equivalent (trouble.nvim not installed)

3. **`<leader>xX`** - Toggle Trouble buffer diagnostics
   - Old: Open buffer diagnostics in Trouble window
   - New: No equivalent (trouble.nvim not installed)

4. **`]q` / `[q`** - Next/Previous Trouble item (with fallback to quickfix)
   - Old: Smart navigation between Trouble items or quickfix
   - New: No equivalent (trouble.nvim not installed)

5. **`<C-r>` in insert mode** - Jump to or apply next edit suggestion (sidekick.nvim)
   - Old: Navigate AI edit suggestions
   - New: `<C-r>` is used for Copilot accept (changed from `<C-r>` to `<C-e>`)

6. **`<leader>ci`** - Highlight surrounding pairs (vim-matchup)
   - Old: Temporarily highlight matching pairs
   - New: No equivalent (vim-matchup commented out)

7. **`<leader>uv`** - Toggle Vimade (screen dimming)
   - Old: Toggle inactive window dimming
   - New: Vimade in experimental.lua, toggle keybinding may be different

8. **`<leader>uH`** - Toggle Matchup Hi Surround (vim-matchup)
   - Old: Toggle always-highlight surrounding pairs
   - New: No equivalent (vim-matchup commented out)

9. **Opencode Keybinding Changes**:
   - Old: `<C-x>` → New: `<leader>ap` (Execute opencode action)
   - Old: `ga` → New: `<leader>ao` (Add to opencode)
   - Old: `<S-C-u>` → New: `<leader>au` (Opencode half page up)
   - Old: `<S-C-d>` → New: `<leader>ad` (Opencode half page down)
   - Impact: More consistent leader-key organization in new config

10. **Gitsigns Keybindings Missing** (Critical)
   - Old config has comprehensive gitsigns keybindings in `on_attach` callback
   - New config only defines sign symbols, no keybindings
   - Missing keybindings:
     - `]h` / `[h` - Next/Previous hunk
     - `]H` / `[H` - Last/First hunk
     - `<leader>ghs` - Stage hunk (normal/visual)
     - `<leader>ghr` - Reset hunk (normal/visual)
     - `<leader>ghS` - Stage buffer
     - `<leader>ghu` - Undo stage hunk
     - `<leader>ghR` - Reset buffer
     - `<leader>ghp` - Preview hunk inline
     - `<leader>ghb` - Blame line (full)
     - `<leader>ghB` - Blame buffer
     - `<leader>ghd` - Diff this
     - `<leader>ghD` - Diff this ~
     - `ih` - Select hunk (operator/visual)
   - Impact: Git workflow severely limited without these keybindings

---

## LazyVim-Specific Features

The old configuration did not explicitly use LazyVim as a distribution. Some references to `lazyvim_last_loc` exist but appear to be from copied autocmds rather than actual LazyVim integration.

---

## New Features in New Configuration (Not in Old)

These features are present in the new configuration but were not in the old one. This is for reference only - they are not "missing" from the perspective of migration.

### New Plugins

1. **shortcuts/no-neck-pain.nvim** (experimental.lua)
   - Center text area in Neovim with configurable width
   - Toggle with `<leader>un`

2. **nvim-pack/nvim-spectre** (experimental.lua)
   - Project-wide find & replace in a panel
   - `<leader>sf` to toggle, `<leader>sw` to search word, `<leader>sp` for file search

3. **xzbdmw/colorful-menu.nvim** (editor.lua)
   - Enhanced completion menu with colors for blink.cmp

4. **AndreM222/copilot-lualine** (ui.lua)
   - Copilot status in lualine

5. **MeanderingProgrammer/treesitter-modules.nvim** (tooling.lua)
   - Wrapper around nvim-treesitter with additional modules

6. **sustech-data/wildfire.nvim** (tooling.lua)
   - Quick text selection expansion

7. **nvimtools/none-ls.nvim** (tooling.lua)
   - Replacement for null-ls.nvim with diagnostics sources

### Enhanced Autocmds
- Auto-resize splits on terminal resize
- Active window cursorline management
- Dotenv filetype detection
- Improved last location restore with more exclusions

---

## Summary

### Critical Missing Features

1. **lewis6991/gitsigns.nvim keybindings** - All git hunk operations missing
   - Impact: Cannot navigate, stage, reset, preview, or blame hunks
   - 15+ keybindings missing (see Missing Keybindings section)
   - Status: Plugin installed but not configured with keybindings

2. **folke/trouble.nvim** - Enhanced diagnostics viewer with dedicated window
   - Impact: Less convenient diagnostics navigation
   - Keybindings affected: `<leader>xx`, `<leader>xX`, `]q`, `[q`

3. **Incremental selection** - Treesitter-based selection expansion
   - Impact: Cannot expand/shrink selection with `<CR>`/`<bs>`
   - Status: Commented out, can be re-enabled

4. **andymass/vim-matchup** - Enhanced % matching
   - Impact: No offscreen match popup, no `<leader>ci` to highlight surrounds
   - Status: Commented out in experimental.lua

5. **sphamba/smear-cursor.nvim** - Cursor animation
   - Impact: No visual cursor motion feedback
   - Status: Commented out in experimental.lua

### Replaced Features (Need Verification)
1. **Harpoon → Grapple** - File bookmarking
   - Both use similar keybindings (`<leader>h`, `<leader>H`, `<leader>1-9`)
   - Grapple uses git_branch scope vs Harpoon's per-project
   - Need to verify: Feature parity and migration path

2. **nvim-lint → none-ls** - Linting
   - Old: Dedicated linting with debouncing and per-linter config
   - New: none-ls handles linting via builtins
   - Need to verify: All linters migrated and equivalent functionality

3. **mason-tool-installer → mason-null-ls** - Tool installation
   - Both auto-install tools from Mason
   - mason-null-ls is more specific to none-ls integration
   - Need to verify: All tools are installed

4. **folke/sidekick.nvim** - Missing
   - Old: `<C-r>` for next edit suggestion navigation
   - New: No equivalent found
   - Impact: AI edit suggestion workflow different

### Configuration Differences (Minor)
1. **Snacks picker layout**: vertical → sidebar
2. **Mini.files window styling**: Custom height/border → Fixed widths/height
3. **Blink.cmp behavior**: Auto-accept single item → Manual selection
4. **Session keybindings**: `<leader>f` group → `<leader>s` group
5. **Flash.nvim modes**: Different treesitter mode mappings
6. **Catppuccin**: Missing dynamic flavour setting
7. **Auto-session**: Missing bypass_save_filetypes

### Definitely Not Missing (Already Present)
- tadaa/vimade: In experimental.lua (active)
- Most UI plugins (noice, lualine, indent-blankline, rainbow-delimiters, etc.)

---

## Next Steps

### Immediate Actions Needed

1. **Add Gitsigns Keybindings** (Critical)
   - Copy `on_attach` callback from old config to new config
   - 15+ keybindings need to be added to enable git workflow

2. **Decide on Trouble.nvim**
   - Add if enhanced diagnostics navigation is desired
   - Alternative: Use native quickfix or Snacks picker diagnostics

3. **Enable Incremental Selection** (Easy)
   - Uncomment in `tooling.lua` treesitter-modules config
   - Restore `<CR>` and `<bs>` keybindings

4. **Consider Re-enabling**
   - `vim-matchup`: Enhanced % matching (commented in experimental)
   - `smear-cursor`: Visual cursor feedback (commented in experimental)

### Testing Required

1. **Grapple vs Harpoon**
   - Test file tagging and navigation
   - Verify git_branch scope works as expected
   - Confirm keybindings (`<leader>h`, `<leader>H`, `<leader>1-9`) work

2. **none-ls Linting**
   - Verify all linters are working (yamllint, markdownlint-cli2, etc.)
   - Confirm eslint LSP provides equivalent functionality to eslint_d
   - Test diagnostics appear and update correctly

3. **Mason Tool Installation**
   - Verify mason-null-ls installs all required tools
   - Compare with old mason-tool-installer behavior

### Documentation Updates

1. Update README/docs to reflect new keybindings
2. Document replaced features and migration notes
3. Note any workflow changes (e.g., automatic vs manual linting)

### Verified Complete

1. ✅ Core functionality (options, autocmds, keymaps) largely preserved
2. ✅ All major plugins accounted for (either present or replaced)
3. ✅ Formatting configuration equivalent (conform.nvim in both)
4. ✅ LSP configuration modernized (using vim.lsp.config + vim.lsp.enable)
5. ✅ Completion modernized (blink.cmp with better configuration)
6. ✅ UI plugins mostly complete (with some in experimental)
7. ✅ AI tools preserved (Copilot + opencode.nvim with reorganized keybindings)

---

## Final Assessment

### Migration Completeness: ~85%

**Major Issues:**
- Gitsigns keybindings completely missing (blocking for git workflow)

**Minor Issues:**
- Some visual enhancements commented out (smear-cursor, vim-matchup)
- Incremental selection disabled
- Manual lint trigger missing
- Trouble.nvim not included

**Improvements in New Config:**
- Better LSP integration (vim.lsp.config, inc-rename with keybinding)
- eslint as LSP instead of linter
- More organized keybindings (leader groups)
- Enhanced autocmds (cursorline management, dotenv detection, etc.)
- Better Copilot integration in lualine
- Project-wide find & replace (nvim-spectre)
- No-neck-pain for centered editing
- Colorful completion menu

**Overall:** The new configuration is well-structured and includes improvements, but needs critical gitsigns keybindings restored and some decisions on commented features.
