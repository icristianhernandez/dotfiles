# Custom Keymaps with Vanilla/Builtin Vim Equivalents

This document lists all custom keymaps in this nvim configuration that have builtin/vanilla vim/neovim equivalents.

## Format: `{my_keymap} : {vanilla_keymap}`

### File Operations

- `<C-s>` : `:w<CR>` (Save file - vanilla uses the command mode)

### Window Management

- `<leader>wq` : `<C-w>q` or `:q<CR>` (Quit window)
- `<leader>wd` : `<C-w>c` (Close current window)
- `<leader>wo` : `<C-w>o` or `:only<CR>` (Close other windows)
- `<leader>ws` : `<C-w>s` or `:split<CR>` (Horizontal split)
- `<leader>wv` : `<C-w>v` or `:vsplit<CR>` (Vertical split)
- `<leader>wa` : `<C-w>_<C-w>|` (Maximize window - same underlying keys)
- `<C-h>` (normal) : `<C-w>h` (Move to left window)
- `<C-j>` (normal) : `<C-w>j` (Move to window below)
- `<C-k>` (normal) : `<C-w>k` (Move to window above)
- `<C-l>` (normal) : `<C-w>l` (Move to right window)

### Clipboard Operations

- `<C-c>` : `"+y` (Yank to system clipboard)
- `<C-v>` (normal) : `"+p` or `"+gP` (Paste from system clipboard)
- `<C-v>` (insert) : `<C-r>+` (Paste from clipboard in insert mode - vanilla uses `<C-r>` register insert)

### Navigation

- `0` : `^` (Swapped: go to first non-blank character)
- `^` : `0` (Swapped: go to first column)
- `<leader><leader>` : `<C-^>` or `<C-6>` (Go to alternate buffer)

### Tab Management

- `<leader><Tab><Tab>` : `:tabnew<CR>` (Open new tab)
- `<leader><Tab>d` : `:tabclose<CR>` (Close current tab)
- `<leader><Tab>o` : `:tabonly<CR>` (Close other tabs)
- `<leader><Tab>1` : `1gt` (Go to tab 1)
- `<leader><Tab>2` : `2gt` (Go to tab 2)
- `<leader><Tab>3` : `3gt` (Go to tab 3)
- `<leader><Tab>4` : `4gt` (Go to tab 4)
- `<leader><Tab>5` : `5gt` (Go to tab 5)
- `<leader><Tab>6` : `6gt` (Go to tab 6)
- `<leader><Tab>7` : `7gt` (Go to tab 7)
- `<leader><Tab>8` : `8gt` (Go to tab 8)
- `<leader><Tab>9` : `9gt` (Go to tab 9)

### Movement (Enhanced)

- `j` : `gj` (When count=0, move by display line instead of actual line)
- `k` : `gk` (When count=0, move by display line instead of actual line)
- `<Down>` : `gj` (Same as j enhancement)
- `<Up>` : `gk` (Same as k enhancement)

### Search (Enhanced)

- `n` : `n` or `N` (Saner behavior: always search forward regardless of `/` or `?`)
- `N` : `N` or `n` (Saner behavior: always search backward regardless of `/` or `?`)

### Visual Mode

- `<` (visual) : `<gv` (Indent left and reselect - vanilla `<` exits visual mode)
- `>` (visual) : `>gv` (Indent right and reselect - vanilla `>` exits visual mode)
- `p` (visual) : `p` (Keep last yanked when pasting - uses black hole register)

### Bracket Remapping

- `{` : `[` (Remapped for easier access)
- `}` : `]` (Remapped for easier access)

### Insert Mode Delete Word

- `<C-BS>` (insert/cmdline) : `<C-w>` (Delete word backward)
- `<C-h>` (insert) : `<C-w>` (Delete word backward - vanilla `<C-h>` is backspace)
