# Missing Functionality from nvim-old (Deprecated Config)

This document tracks missing features from the old Neovim configuration (`nvim-old/`) that have not yet been migrated to the new configuration (`nvim/`).

## Executive Summary

**Overall Assessment:** The new configuration is largely an **improvement** over the old one, with better linting, enhanced features, and architectural improvements. However, there is **1 critical missing feature** (gitsigns keybindings) and a few workflow changes that users should be aware of.

**Critical Issue:**
- ❌ **Gitsigns keybindings missing** - Git hunk manipulation workflow completely absent

**Recommended Actions:**
1. Add gitsigns `on_attach` keybindings (critical)
2. Decide on Trouble.nvim (nice-to-have for diagnostics UI)
3. Review Copilot auto-trigger setting (currently disabled)
4. Consider adding sidekick.nvim if AI workflow needs it

**Notable Improvements:**
- ✅ Better linting (ESLint LSP + more linters)
- ✅ Enhanced autocmds (auto-diagnostics, cursorline management)
- ✅ Better tooling architecture
- ✅ 17 new plugins with enhancements

**Configuration Changes:**
- Copilot accept: `<C-r>` → `<C-e>`
- Copilot auto-trigger: enabled → **disabled**
- Opencode actions: `<C-x>` → `<leader>ap`, `ga` → `<leader>ao`
- Session management: `<leader>f` → `<leader>s` prefix

---

## Status Legend
- ❌ Missing: Feature is present in old config but not in new config
- ✅ Migrated: Feature has been migrated (possibly with changes)
- 🔄 Replaced: Feature replaced with equivalent/better alternative
- 💡 Improved: Feature reimplemented with improvements

## LazyVim Framework Usage

**Finding:** The old configuration does **NOT** use LazyVim as a framework. Both configs use `lazy.nvim` (the plugin manager) but are custom configurations.

**Evidence:**
- No `{ import = "lazyvim.plugins" }` or similar LazyVim imports
- No LazyVim-specific structure or conventions
- Only reference is a comment about a LazyVim setting
- The `lazyvim_last_loc` flag in old config is just borrowed naming, not actual LazyVim integration

**Conclusion:** No LazyVim-specific functionality to migrate.

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

**Impact:** Users who rely on iterating through multiple Copilot suggestions will need to use default Copilot panel or find alternative workflow.

---

### 3. 💡 AI Keybinding Changes - `opencode.nvim`
**Status:** Keybindings reorganized (not missing, just different)

**Old keybindings:**
- `<leader>aa` - Ask opencode (with @this context)
- `<C-x>` - Execute opencode action menu
- `ga` - Add to opencode (prompt with @this)
- `<C-a>` - Toggle opencode terminal
- `<S-C-u>` / `<S-C-d>` - Half page up/down in opencode

**New keybindings:**
- `<leader>aa` - Ask opencode (same)
- `<leader>ap` - Execute opencode action (changed from `<C-x>`)
- `<leader>ao` - Add to opencode (changed from `ga`)
- `<c-a>` - Toggle opencode (same, lowercase)
- `<leader>au` / `<leader>ad` - Half page navigation (changed from Shift-Ctrl)

**Impact:** Users need to learn new keybindings. New approach groups all opencode commands under `<leader>a` prefix (more discoverable with which-key).

---

### 3. 💡 AI Keybinding Changes - `opencode.nvim`
**Status:** Keybindings reorganized (not missing, just different)

**Old keybindings:**
- `<leader>aa` - Ask opencode (with @this context)
- `<C-x>` - Execute opencode action menu
- `ga` - Add to opencode (prompt with @this)
- `<C-a>` - Toggle opencode terminal
- `<S-C-u>` / `<S-C-d>` - Half page up/down in opencode

**New keybindings:**
- `<leader>aa` - Ask opencode (same)
- `<leader>ap` - Execute opencode action (changed from `<C-x>`)
- `<leader>ao` - Add to opencode (changed from `ga`)
- `<c-a>` - Toggle opencode (same, lowercase)
- `<leader>au` / `<leader>ad` - Half page navigation (changed from Shift-Ctrl)

**Impact:** Users need to learn new keybindings. New approach groups all opencode commands under `<leader>a` prefix (more discoverable with which-key).

---

### 4. 💡 Copilot Configuration Changes

**Old config:**
- Accept suggestion: `<C-r>`
- Panel: disabled
- Auto-trigger: implicit (default true)

**New config:**
- Accept suggestion: `<C-e>`
- Panel: disabled
- Auto-trigger: **explicitly false**
- Filetypes: explicitly enabled for all (`["*"] = true`)

**Impact:** 
- Changed keybinding: `<C-r>` → `<C-e>` for accepting suggestions
- Auto-trigger disabled means Copilot won't show suggestions automatically (must trigger manually)
- This is a significant workflow change that may or may not be intentional

---

### 5. 🔄 File Bookmarking - `ThePrimeagen/harpoon` → `cbochs/grapple.nvim`
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

### 6. 🔄 Linting - `mfussenegger/nvim-lint` → `nvimtools/none-ls.nvim`
**Old config location:** `nvim-old/lua/modules/tooling.lua`  
**New config location:** `nvim/lua/modules/tooling.lua`

**Status:** Linting approach changed and IMPROVED

**Old approach (nvim-lint):**
- Dedicated linting plugin with debouncing
- Per-filetype linter configuration
- Events: `BufReadPost`, `BufWritePost`, `InsertLeave`
- Debounce: 300ms
- Manual lint trigger: `<leader>cl`
- Linters:
  - JavaScript/TypeScript: `eslint_d`
  - Markdown: `markdownlint-cli2`

**New approach (none-ls + LSP):**
- Uses none-ls (null-ls successor) for diagnostics
- `jay-babu/mason-null-ls.nvim` for tool installation
- Configuration via null-ls builtins
- ESLint as LSP (better integration than separate linter)
- Enhanced linter coverage:
  - JavaScript/TypeScript: ESLint LSP
  - Markdown: `markdownlint-cli2`
  - YAML: `yamllint`
  - JSON: `jsonlint`
  - Nix: `statix`
  - Shell: `shellcheck`, `fish`
  - SQL: `sqlfluff`
  - Git: `commitlint`, `gitlint`, gitsigns code actions

**Comparison:**
- ✅ ESLint via LSP (better than eslint_d as separate linter)
- ✅ More comprehensive linter coverage
- ❌ Missing manual lint trigger keybinding (`<leader>cl`)
- ❌ No explicit debouncing configuration (relies on LSP/none-ls defaults)

**Action needed:** Add manual diagnostic refresh keybinding to replace `<leader>cl`

---

### 7. ❌ Tool Installation - `WhoIsSethDaniel/mason-tool-installer.nvim`
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

### 8. 💡 Visual Effects - Commented in Experimental

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

## New Features & Improvements in New Config

These are enhancements not present in the old config:

### New Plugins (17 total)
1. **cbochs/grapple.nvim** - Replaces Harpoon with git-branch scoping
2. **MeanderingProgrammer/treesitter-modules.nvim** - Modern treesitter configuration
3. **nvimtools/none-ls.nvim** - Successor to null-ls for diagnostics
4. **jay-babu/mason-null-ls.nvim** - Mason integration for none-ls
5. **shortcuts/no-neck-pain.nvim** - Center text area (experimental)
6. **nvim-pack/nvim-spectre** - Project-wide find & replace (experimental)
7. **sustech-data/wildfire.nvim** - Smart selection expansion
8. **xzbdmw/colorful-menu.nvim** - Enhanced blink.cmp menu colors
9. **AndreM222/copilot-lualine** - Copilot status in lualine
10. **b0o/SchemaStore.nvim** - JSON/YAML schema store (was in old, now explicit)
11. **p00f/clangd_extensions.nvim** - Enhanced C/C++ LSP (was in old, now explicit)
12. **rafamadriz/friendly-snippets** - Snippet collection for blink.cmp
13. **MunifTanjim/nui.nvim** - UI library (dependency)
14. **nvim-lua/plenary.nvim** - Lua utilities (dependency)
15. **NMAC427/guess-indent.nvim** - Auto-detect indentation
16. **smjonas/inc-rename.nvim** - Incremental LSP rename with preview
17. **mason-org/mason.nvim** - Tool installer (was implicit, now explicit)

### Enhanced Features
1. **Auto-diagnostics on CursorHold** - Toggle with `<leader>cD`
2. **Improved last location restore** - Better exclusion logic
3. **Cursorline only in active windows** - Visual focus indicator
4. **LSP reference underline highlights** - Persistent across colorscheme changes
5. **Better Copilot configuration** - Explicit filetypes, disabled auto-trigger
6. **Enhanced opencode integration** - Custom contexts for git diffs, commit messages
7. **Lualine parent path caching** - Performance optimization
8. **More comprehensive linting** - YAML, JSON, Nix, Shell, SQL, Git linters
9. **Dotenv syntax highlighting** - Auto-detect .env files
10. **Mini.files with Snacks integration** - File rename integration

### Architectural Improvements
1. **Modular tooling configuration** - Centralized stacks system
2. **Better plugin organization** - Related plugins grouped logically
3. **Core directory structure** - Better separation of concerns
4. **Improved autocmds** - More robust and feature-rich
5. **Better LSP setup** - Using new vim.lsp.config API

---

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
- Navigation: `]h`, `[h`, `]H`, `[H`
- Visual mode stage/reset support
- Hunk text objects: `ih` (select hunk)

**New config:**
- Minimal configuration, only sign definitions
- **MISSING** keybinding setup in `on_attach`
- No git hunk manipulation keybindings configured

**Impact:** ❌ **CRITICAL** - All gitsigns keybindings are missing in the new config. Users cannot stage, reset, preview, or navigate git hunks without adding these keybindings back.

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

#### Keymaps (`keymaps.lua` vs `core/keymaps.lua`)
**Status:** ✅ Essentially identical (126 vs 128 lines)

**Only difference:**
- New config has improved `cmd_delete_word()` implementation using `nvim_feedkeys` for better command-line mode behavior

#### Autocmds (`autocmds.lua` vs `core/autocmds.lua`)
**Status:** 💡 New config has improvements (121 vs 181 lines)

**Old config features:**
- Basic help pages in new tab
- Last location restore (with `lazyvim_last_loc` flag)
- Auto-create parent directories
- Resize splits on VimResized

**New config additions (improvements):**
- ✅ Better last location restore with more exclusions
- ✅ Cursorline only in active windows
- ✅ Dotenv file syntax highlighting
- ✅ Toggle for auto-diagnostics on CursorHold (`<leader>cD`)
- ✅ LSP reference highlight underlines

**Impact:** New config has improvements, no missing functionality

#### Other files
- `neovide.lua`, `wsl.lua`: Organization change (moved to `core/`), functionality appears identical

---

## Mini.files Window Styling

**Old config:** `nvim-old/lua/modules/extras/files.lua`

The old config had custom window styling for mini.files:
- Rounded borders
- Dynamic height calculation (max 15, min based on available space)
- Title position: left
- Window blend: 0
- Autocmds for `MiniFilesWindowOpen` and `MiniFilesWindowUpdate`

**New config:** Window styling is inline in `editor.lua`
- Height calculation: `math.max(math.floor(vim.o.lines * 0.20), 14)`
- No border customization
- Integrated with Snacks rename functionality
- Different window size configuration

**Impact:** Styling approach changed but functionality exists. The old extras/files.lua module is no longer needed as the logic is inline.

---

## Summary & Priority Assessment

### 🔴 Critical Missing Features (High Priority)
1. **Gitsigns keybindings** - ❌ Complete hunk manipulation workflow missing
   - Impact: Cannot stage, reset, preview, navigate, or blame hunks
   - Action: Must add `on_attach` configuration with all keybindings
   - Estimated effort: Low (copy from old config)

2. **Trouble.nvim** - ❌ No diagnostics/quickfix UI
   - Impact: Less efficient diagnostics and quickfix navigation
   - Action: Decide if Trouble should be added or if Snacks picker is sufficient
   - Estimated effort: Low (plugin already configured in old config)

### 🟡 Medium Priority (Consider for Migration)
3. **Mason-tool-installer** - ❌ Automatic tool installation
   - Impact: Tools may not auto-install on new systems
   - Current: Manual installation or partial coverage via mason-null-ls
   - Action: Evaluate if manual installation is acceptable or add plugin
   - Estimated effort: Low

4. **Sidekick.nvim** - ❌ AI edit suggestion navigation
   - Impact: Less efficient Copilot workflow
   - Action: Evaluate if workflow needs this feature
   - Estimated effort: Low

5. **Manual linting trigger** - ❌ Missing `<leader>cl` keybinding
   - Impact: Cannot manually trigger diagnostics refresh
   - Action: Add keybinding for diagnostic refresh
   - Note: Linting itself is IMPROVED in new config (ESLint LSP + more linters)
   - Estimated effort: Minimal

### 🟢 Low Priority (Optional/Experimental)
6. **Vim-matchup** - 💡 Commented out in experimental
   - Impact: No enhanced % matching or surround highlighting
   - Action: Uncomment if needed, or use default Vim % matching
   - Status: Intentionally disabled

7. **Smear-cursor** - 💡 Commented out in experimental
   - Impact: No cursor animation
   - Action: Uncomment if visual feedback desired
   - Status: Intentionally disabled (experimental feature)

### ✅ Successfully Migrated/Replaced
- **Harpoon → Grapple** - File bookmarking (feature parity)
- **nvim-lint → none-ls + ESLint LSP** - Linting (IMPROVED with better coverage)
- **Core files** - Keymaps, autocmds (improved in new config)
- **Plugin organization** - cmp, snacks, treesitter integrated into main modules

### 📊 Migration Statistics
- **Total plugins in old config:** 45
- **Total plugins in new config:** 57
- **Missing plugins:** 7 (1 critical, 3 medium, 3 optional)
- **New plugins:** 17 (improvements and additions)
- **Replaced/Improved plugins:** 3

---

## Action Items & Recommendations

### Immediate Actions (Required)
1. ✅ Add gitsigns `on_attach` keybindings from old config
2. ✅ Add manual diagnostics refresh keybinding (to replace `<leader>cl`)

### Evaluation Needed
3. Decide on Trouble.nvim migration (or document Snacks picker as replacement)
4. Evaluate Sidekick.nvim necessity for AI workflow
5. Review mason-tool-installer need vs manual installation

### Optional/Deferred
7. Consider uncommenting vim-matchup in experimental if % matching enhancements desired
8. Consider uncommenting smear-cursor if animation desired

### Documentation
9. Document keybinding changes (session management: `<leader>f` → `<leader>s`)
10. Document architectural changes (module organization)
11. Update user guides if gitsigns keybindings are added
