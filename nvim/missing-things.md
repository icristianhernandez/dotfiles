# Missing Functionality from nvim-old (Deprecated Config)

This document tracks missing features from the old Neovim configuration (`nvim-old/`) that have not yet been migrated to the new configuration (`nvim/`).

## Status Legend
- ❌ Missing: Feature is present in old config but not in new config
- ✅ Migrated: Feature has been migrated (possibly with changes)
- 🔄 Replaced: Feature replaced with equivalent/better alternative
- 💡 Improved: Feature reimplemented with improvements

---

## Missing Plugins & Features

### 1. ❌ Diagnostics & Quickfix - `folke/trouble.nvim`
**Old config location:** `nvim-old/lua/modules/editor.lua`

**Description:** Trouble provides a beautiful list for showing diagnostics, references, telescope results, quickfix and location lists.

**Usage in old config:**
- Keybindings:
  - `<leader>xx` - Toggle diagnostics (Trouble)
  - `<leader>xX` - Buffer diagnostics (Trouble)
  - `[q` / `]q` - Navigate Trouble/Quickfix items with smart fallback
- Advanced features:
  - Position: right window
  - Integration with quickfix navigation

**Migration notes:**
- The new config does not include trouble.nvim
- Quickfix navigation may be more basic without trouble
- Consider migrating or finding alternative solution

---

### 2. ❌ Copilot Edit Suggestions - `folke/sidekick.nvim`
**Old config location:** `nvim-old/lua/modules/ai.lua`

**Description:** Sidekick provides next edit suggestion jumping and applying for AI assistants.

**Usage in old config:**
- Keybinding: `<C-r>` - Jump to or apply next edit suggestion
- Integration with Copilot for enhanced editing flow

**Migration notes:**
- Not present in new config
- Functionality for iterating through AI suggestions is missing
- May impact workflow with AI assistants

---

### 3. 🔄 File Bookmarking - `ThePrimeagen/harpoon` → `cbochs/grapple.nvim`
**Old config location:** `nvim-old/lua/modules/editor.lua`  
**New config location:** `nvim/lua/modules/editor.lua`

**Status:** REPLACED with Grapple

**Harpoon features:**
- Quick file bookmarking with `<leader>H`
- Navigate bookmarks with `<leader>h` (menu) and `<leader>1-9`
- Settings: `save_on_toggle = true`

**Grapple features:**
- Tag files with `<leader>H`
- Toggle tags window with `<leader>h`
- Select tag by index `<leader>1-9`
- Scope: `git_branch` (branch-aware tagging)

**Comparison:**
- Both provide similar functionality
- Grapple adds git branch-aware scoping
- Keybindings are identical (no migration needed)
- ✅ Feature parity maintained

---

### 4. ❌ Linting - `mfussenegger/nvim-lint` → `nvimtools/none-ls.nvim`
**Old config location:** `nvim-old/lua/modules/tooling.lua`  
**New config location:** `nvim/lua/modules/tooling.lua`

**Status:** Linting approach changed

**Old approach (nvim-lint):**
- Dedicated linting plugin with debouncing
- Per-filetype linter configuration
- Events: `BufReadPost`, `BufWritePost`, `InsertLeave`
- Debounce: 300ms
- Manual lint trigger: `<leader>cl`

**New approach (none-ls):**
- Uses none-ls (null-ls successor) for diagnostics
- `jay-babu/mason-null-ls.nvim` for tool installation
- Configuration via null-ls builtins
- Methods-based approach for diagnostics

**Potential gaps:**
- Old config had explicit linters configuration with debouncing
- Old config had dedicated `<leader>cl` keybinding for manual linting
- Need to verify all linters from old config are configured in new config

---

### 5. ❌ Tool Installation - `WhoIsSethDaniel/mason-tool-installer.nvim`
**Old config location:** `nvim-old/lua/modules/tooling.lua`

**Description:** Automatic installation and management of external tools (formatters, linters, DAPs).

**Usage in old config:**
- Auto-installs tools on startup
- `run_on_start = true`
- `start_delay = 3000` (3 second delay)
- Ensures configured tools are always present

**Migration notes:**
- New config uses `jay-babu/mason-null-ls.nvim` for some tool management
- But mason-tool-installer provided broader tool installation (not just null-ls tools)
- May need manual tool installation or different approach
- Check if all required external tools are properly installed

---

### 6. 💡 Visual Effects - Commented in Experimental

#### a. `sphamba/smear-cursor.nvim`
**Old config location:** `nvim-old/lua/modules/ui.lua`  
**New config location:** `nvim/lua/modules/experimental.lua` (COMMENTED OUT)

**Status:** Feature disabled in new config

**Old config:**
- Enabled with conditions: `cond = vim.g.neovide == nil`
- Options: `never_draw_over_target = true`, `hide_target_hack = true`, `damping = 1.0`

**New config:**
- Commented out in experimental.lua
- Less aggressive animation settings when enabled

**Impact:** Cursor animation missing in new config

#### b. `andymass/vim-matchup`
**Old config location:** `nvim-old/lua/modules/ui.lua`  
**New config location:** `nvim/lua/modules/experimental.lua` (COMMENTED OUT)

**Status:** Feature disabled in new config

**Old config features:**
- Enhanced `%` matching with treesitter
- Offscreen matching in popup
- Deferred matching for performance
- Surround highlighting toggle with `<leader>uH`
- Manual highlight with `<leader>ci`

**New config:**
- Completely commented out
- All configuration preserved in comments

**Impact:** 
- No enhanced % matching beyond Vim's default
- No surround highlighting features
- Missing `<leader>uH` and `<leader>ci` keybindings

---

## Configuration Differences

### Lazy.nvim Setup
Both configs use the same lazy.nvim setup with minor differences:

**Old config:**
- Default colorscheme: `catppuccin`
- No explicit lazy keymap

**New config:**
- Includes `<leader>l` keymap to open Lazy UI
- More defensive loading check

---

### Auto-session Configuration
**Differences:**
- Old: `bypass_save_filetypes = { "alpha", "dashboard" }`
- New: No bypass configuration
- Old: Session search with `<leader>fs`, delete with `<leader>fS`
- New: Session search with `<leader>ss`, delete with `<leader>sS`

**Impact:** Keybinding changes for session management

---

### Gitsigns Configuration
**Old config:**
- Complete hunk manipulation keybindings in `on_attach`
- Keybindings: stage (`<leader>ghs`), reset (`<leader>ghr`), preview, blame, diff, etc.

**New config:**
- Minimal configuration, only sign definitions
- Missing keybinding setup in `on_attach`

**Impact:** Need to verify gitsigns keybindings are defined elsewhere or are missing

---

## Files & Directories Comparison

### Modules Present in Old but Not in New (as separate files)
1. `cmp.lua` - Integrated into `editor.lua` in new config
2. `snacks.lua` - Integrated into `editor.lua` in new config  
3. `treesitter.lua` - Integrated into `tooling.lua` in new config

These are organizational changes, not missing functionality.

### Extras Files
**Old:**
- `extras/files.lua` - Mini.files window styling customization
- `extras/tooling.lua` - Centralized tooling configuration

**New:**
- `extras/lualine_cache.lua` - Lualine parent path caching
- `extras/tooling.lua` - Similar centralized tooling

**Impact:** Mini.files window styling helpers from old config missing

---

## Core Configuration Files

### Options (`options.lua` vs `core/options.lua`)
Minor differences:
- Guicursor: New config adds `c` and `t` modes to blinking cursor
- Completeopt: New config adds `menuone`, `noselect`, `popup`
- Update time: 160ms (old) → 100ms (new)
- Showtabline: Changed from `opt` to `o` API

### Other Core Files
- `keymaps.lua`, `autocmds.lua`, `neovide.lua`, `wsl.lua`: Need detailed comparison
- File organization: Old uses flat structure, new uses `core/` directory

---

## Summary

### Critical Missing Features
1. **Trouble.nvim** - No diagnostics/quickfix UI
2. **Sidekick.nvim** - No AI edit suggestion navigation  
3. **Manual linting trigger** - `<leader>cl` keybinding missing
4. **Mason-tool-installer** - Automatic tool installation missing
5. **Gitsigns keybindings** - Hunk manipulation keybindings may be missing
6. **Mini.files window styling** - Custom window style helpers missing

### Features Replaced Successfully
1. **Harpoon → Grapple** - File bookmarking maintained
2. **nvim-lint → none-ls** - Linting approach changed (verify completeness)

### Features Disabled (In Experimental)
1. **Smear-cursor** - Cursor animation
2. **Vim-matchup** - Enhanced % matching and surround highlighting

### Next Steps
1. Verify gitsigns keybindings in new config
2. Compare detailed keymaps, autocmds, and other core files
3. Check if linting configuration is complete in none-ls setup
4. Decide on trouble.nvim migration priority
5. Evaluate if sidekick.nvim functionality is needed
6. Review mini.files extras for potential migration
