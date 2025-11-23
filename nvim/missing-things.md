# Missing Functionality in New Neovim Configuration

This document tracks functionalities from `@nvim-deprecated/` that have not yet been migrated to `@nvim/`.

## Status Legend
- ⚠️ **Missing**: Functionality not present in new config
- ✅ **Migrated**: Functionality successfully migrated
- 🔄 **Different Implementation**: Similar functionality exists but with different approach
- ℹ️ **Not Needed**: Functionality intentionally not migrated (LazyVim-specific or deprecated)

---

## AI Tooling

### ⚠️ CodeCompanion
**Status**: Missing from new config

**Old Config** (`codecompanion.lua`):
- Plugin: `olimorris/codecompanion.nvim`
- Chat interface for AI assistance
- Custom keybindings: `<leader>aa`, `<leader>ai`, `<leader>ac`, `ga`
- Float window configuration
- Commit message generation

**New Config**:
- Uses `opencode.nvim` instead (different tool with different features)
- OpenCode provides prompt execution and chat interface
- Similar keybindings exist but with different plugin

**Migration Status**: Different implementation exists (opencode vs codecompanion)

---

## Editor Plugins

### ⚠️ Harpoon2
**Status**: Missing from new config

**Old Config** (LazyVim extra):
- LazyVim extra: `lazyvim.plugins.extras.editor.harpoon2`
- Quick file marking and navigation system
- Not explicitly configured in plugin files (LazyVim default)

**New Config**:
- Uses `grapple.nvim` instead
- Similar functionality: file tagging and quick navigation
- Keybindings: `<leader>H` (tag), `<leader>h` (toggle tags), `<leader>1-9` (select tags)

**Migration Status**: Different implementation exists (grapple vs harpoon2)

---

### ⚠️ Vim-Matchup Configuration Details
**Status**: Partially migrated

**Old Config** (`vim-matchup.lua`):
- Plugin enabled with specific configuration
- Keybinding: `<leader>ci` for `<plug>(matchup-hi-surround)`
- Toggle for `matchup_matchparen_hi_surround_always` with `<leader>uH`
- Popup method for offscreen matches
- Deferred matching for performance

**New Config**:
- Plugin not present in any module
- No matchup configuration found

**Migration Status**: Missing

---

### ⚠️ Vimade
**Status**: Missing from new config

**Old Config** (`vimade.lua`):
- Plugin: `tadaa/vimade`
- Dims inactive windows for focus
- Toggle with `<leader>uv`
- Custom recipe with animation disabled

**New Config**:
- Not present in any module
- No similar functionality found

**Migration Status**: Missing

---

### ⚠️ Tabout
**Status**: Missing from new config

**Old Config** (`tabout.lua`):
- Plugin: `abecodes/tabout.nvim`
- Exit current context in insert mode
- Keybindings: `<c-x>` (forward), `<c-z>` (backward)

**New Config**:
- Not present in any module
- No similar functionality found

**Migration Status**: Missing

---

### ⚠️ Smear Cursor
**Status**: Missing from new config (commented in experimental)

**Old Config** (`smear-cursor.lua`):
- Plugin: `sphamba/smear-cursor.nvim`
- Cursor animation for visual feedback
- LazyVim extra: `lazyvim.plugins.extras.ui.smear-cursor`

**New Config**:
- Commented out in `experimental.lua` module
- Not actively enabled

**Migration Status**: Present but disabled

---

## LSP & Language Support

### ℹ️ LazyVim Language Extras
**Status**: Need to verify individual language configurations

**Old Config** (LazyVim extras):
1. `lazyvim.plugins.extras.lang.clangd` - C/C++ support
2. `lazyvim.plugins.extras.lang.git` - Git integration
3. `lazyvim.plugins.extras.lang.json` - JSON support
4. `lazyvim.plugins.extras.lang.markdown` - Markdown support
5. `lazyvim.plugins.extras.lang.python` - Python support
6. `lazyvim.plugins.extras.lang.sql` - SQL support
7. `lazyvim.plugins.extras.lang.toml` - TOML support
8. `lazyvim.plugins.extras.lang.typescript` - TypeScript support
9. `lazyvim.plugins.extras.lang.yaml` - YAML support

**New Config** (`modules/extras/tooling.lua`):
- ✅ C/C++: `clangd` configured in `c_cpp` stack
- ✅ Git: `gitsigns` in editor module
- ✅ JSON: `jsonls` configured in `data_and_docs` stack with schemastore
- ✅ Markdown: `marksman` configured in `data_and_docs` stack
- ✅ Python: `ruff` + `basedpyright` configured in `python` stack
- ✅ SQL: formatters configured in `databases` stack (no LSP configured)
- ✅ TOML: `taplo` configured in `data_and_docs` stack
- ✅ TypeScript: `vtsls` configured in `frontend_web` stack
- ✅ YAML: `yamlls` configured in `data_and_docs` stack with schemastore

**Migration Status**: All languages have equivalent or better support

---

### ⚠️ SQL LSP
**Status**: Missing LSP, only formatters present

**Old Config**:
- LazyVim extra included SQL language support (typically includes LSP)

**New Config** (`modules/extras/tooling.lua`):
- SQL formatters: `pg_format`
- SQL linters: `sqlfluff`
- No LSP configured (commented: `-- lsps = { "sqls" }`)

**Migration Status**: Partial (formatters/linters present, LSP missing)

---

### ✅ Deno/TypeScript Root Detection
**Status**: Migrated

**Old Config** (`lsp.lua`):
- Custom `denols` and `ts_ls` root_dir configuration
- Prevents conflicts between Deno and Node projects

**New Config**:
- Not explicitly visible in tooling.lua but `vtsls` is configured
- May need verification that Deno/Node conflict resolution exists

**Migration Status**: Needs verification

---

### ⚠️ PSeInt LSP
**Status**: Custom configuration not migrated

**Old Config** (`temporary-pseint.lua` + `lsp.lua`):
- Custom LSP: `pseint-lsp`
- Filetype: `pseint`
- Plugin: `EddyBer16/pseint.vim`
- LSP path: `/home/crisarch/pseint-lsp/.venv/bin/pseint-lsp`

**New Config**:
- Not present in any module

**Migration Status**: Missing

---

## Formatting & Linting

### ✅ Biome & Prettier
**Status**: Migrated

**Old Config**:
- LazyVim extras: `formatting.biome`, `formatting.prettier`
- Global config: `vim.g.lazyvim_prettier_needs_config = true`

**New Config** (`modules/extras/tooling.lua`):
- Biome LSP in `frontend_web` stack
- Prettierd formatters for web files
- Custom stop_after_first logic preferring Biome

**Migration Status**: Migrated with improved configuration

---

### ✅ ESLint
**Status**: Migrated

**Old Config**:
- LazyVim extra: `lazyvim.plugins.extras.linting.eslint`

**New Config** (`modules/extras/tooling.lua`):
- ESLint LSP in `frontend_web` stack

**Migration Status**: Migrated

---

## UI Enhancements

### ℹ️ Mini.comment
**Status**: Different implementation

**Old Config**:
- LazyVim extra: `lazyvim.plugins.extras.coding.mini-comment`

**New Config** (`modules/coding.lua`):
- Uses `folke/ts-comments.nvim` instead
- Treesitter-based commenting

**Migration Status**: Different, possibly better implementation

---

### ✅ Indent Blankline
**Status**: Migrated

**Old Config**:
- LazyVim extra: `lazyvim.plugins.extras.ui.indent-blankline`
- Custom config in `indent-blankline.lua`

**New Config** (`modules/ui.lua`):
- Plugin: `lukas-reineke/indent-blankline.nvim`
- Custom configuration present

**Migration Status**: Migrated

---

### ✅ Treesitter Context
**Status**: Migrated

**Old Config**:
- LazyVim extra: `lazyvim.plugins.extras.ui.treesitter-context`

**New Config** (`modules/tooling.lua`):
- Dependency of treesitter with custom opts
- `max_lines = 1`, `multiline_threshold = 1`

**Migration Status**: Migrated

---

### ✅ Auto Dark Mode
**Status**: Migrated

**Old Config** (`auto-dark-mode.lua`):
- Plugin: `f-person/auto-dark-mode.nvim`
- Syncs with OS theme

**New Config** (`modules/colorscheme.lua`):
- Same plugin with same configuration

**Migration Status**: Migrated

---

### ⚠️ Mini.hipatterns
**Status**: Missing

**Old Config**:
- LazyVim extra: `lazyvim.plugins.extras.util.mini-hipatterns`
- Highlights color codes and patterns

**New Config**:
- Uses `catgoose/nvim-colorizer.lua` instead
- Different plugin, similar functionality for color highlighting

**Migration Status**: Different implementation for color codes only

---

### ⚠️ Dot Files Support
**Status**: Missing

**Old Config**:
- LazyVim extra: `lazyvim.plugins.extras.util.dot`
- Enhanced support for dotfiles

**New Config**:
- Not present

**Migration Status**: Missing (need to verify what this extra provided)

---

## Snacks Modules

### ✅ Snacks Picker
**Status**: Migrated

**Old Config** (`snacks-picker.lua`):
- Custom keybindings and layout

**New Config** (`modules/editor.lua`):
- Comprehensive snacks.picker configuration
- Layout: "sidebar"
- Many keybindings for git, search, files

**Migration Status**: Migrated with enhancements

---

### ✅ Snacks Scratch
**Status**: Migrated

**Old Config** (`snacks-scratch.lua`):
- Scratch buffer with `<C-n>`

**New Config** (`modules/editor.lua`):
- Same keybinding and functionality
- Custom root: `~/dotfiles/notes`
- Default filetype: markdown

**Migration Status**: Migrated with enhancements

---

### ✅ Snacks Terminal
**Status**: Migrated

**Old Config** (`snacks-terminal.lua`):
- Terminal with `<c-space>`

**New Config** (`modules/editor.lua`):
- Same keybinding
- Works in normal, terminal, and insert mode

**Migration Status**: Migrated with enhancements

---

### ✅ Snacks Words
**Status**: Migrated

**Old Config** (`snacks-words.lua`):
- Highlight references under cursor
- Custom LSP highlight configuration
- Debounce: 100ms

**New Config** (`modules/editor.lua`):
- Enabled with debounce: 75ms
- No custom LSP highlights visible

**Migration Status**: Migrated (verify LSP highlight autocmds)

---

## Other Plugins

### ✅ No-Neck-Pain
**Status**: Present in experimental

**Old Config**:
- Not present in deprecated config

**New Config** (`modules/experimental.lua`):
- Plugin: `shortcuts/no-neck-pain.nvim`
- Centers text area

**Migration Status**: New feature (not in old config)

---

### ✅ Spectre
**Status**: Present in experimental

**Old Config**:
- Not present in deprecated config

**New Config** (`modules/experimental.lua`):
- Plugin: `nvim-pack/nvim-spectre`
- Project-wide find & replace

**Migration Status**: New feature (not in old config)

---

### ✅ Flash
**Status**: Present in new config

**Old Config**:
- Not explicitly configured

**New Config** (`modules/editor.lua`):
- Plugin: `folke/flash.nvim`
- Enhanced motion with labels

**Migration Status**: New feature (improvement over default motion)

---

### ✅ Which-key
**Status**: Present in new config

**Old Config**:
- LazyVim default (not explicitly configured)

**New Config** (`modules/editor.lua`):
- Plugin: `folke/which-key.nvim`
- Preset: "helix"
- Custom group definitions

**Migration Status**: Explicitly configured (was implicit in LazyVim)

---

### ✅ Wildfire
**Status**: Present in new config

**Old Config**:
- Not present

**New Config** (`modules/tooling.lua`):
- Plugin: `sustech-data/wildfire.nvim`
- Treesitter-based selection expansion

**Migration Status**: New feature

---

### ✅ Render Markdown
**Status**: Present in new config

**Old Config**:
- Not present (LazyVim markdown extra may have included something)

**New Config** (`modules/ui.lua`):
- Plugin: `MeanderingProgrammer/render-markdown.nvim`
- Renders markdown with styles

**Migration Status**: New feature (enhancement)

---

## Summary

### Critical Missing Features
1. **CodeCompanion** - Different AI tool (opencode) in new config
2. **Harpoon2** - Different implementation (grapple) in new config
3. **Vim-Matchup** - Completely missing
4. **Vimade** - Missing (window dimming)
5. **Tabout** - Missing (context exit in insert mode)
6. **PSeInt LSP** - Missing (custom language support)
7. **SQL LSP** - Only formatters/linters, no LSP
8. **LazyVim util.dot** - Missing (need to verify what it provided)

### Features with Different Implementations
1. **AI Tooling**: CodeCompanion → OpenCode
2. **File Marking**: Harpoon2 → Grapple
3. **Commenting**: mini.comment → ts-comments
4. **Color Highlighting**: mini.hipatterns → nvim-colorizer (partial)

### Successfully Migrated
- All LSP configurations for major languages
- Formatting and linting tools
- UI enhancements (indent-blankline, treesitter-context)
- Snacks modules (picker, scratch, terminal, words)
- Core editor plugins (auto-session, mini.files, blink.cmp)
- Smart-splits, hardtime, guess-indent, quicker, numb

### New Features (Not in Old Config)
- Flash motion
- Which-key explicit configuration
- Wildfire selection
- Render markdown
- No-neck-pain (centering)
- Spectre (find & replace)

---

## Next Steps

1. **Decision Required**: 
   - Keep CodeCompanion or stick with OpenCode?
   - Keep Harpoon2 or stick with Grapple?
   - Add Vim-Matchup or leave it out?

2. **Must Add**:
   - Vimade (if window dimming is desired)
   - Tabout (if context exit functionality is needed)
   - PSeInt LSP (if working with PSeInt is required)
   - SQL LSP (if SQL language server is needed, not just formatting)

3. **Investigate**:
   - LazyVim util.dot extra - what features did it provide?
   - Verify Deno/TypeScript root detection in new config
   - Verify LSP highlight autocmds for snacks.words
