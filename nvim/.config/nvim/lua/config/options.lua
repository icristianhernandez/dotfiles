-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- use independent clipboard for neovim
-- vim.opt.clipboard = ""

-- True color
vim.o.termguicolors = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- change identation to 4 spaces
vim.opt.tabstop = 8
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- show line numbers
vim.opt.number = true
vim.opt.numberwidth = 4

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Incremental live completion
vim.opt.inccommand = "split"

-- determines the number of lines above and below the cursor that
-- remain visible even when scrolling
vim.opt.scrolloff = 7

-- blink cursor
vim.o.guicursor = "i-ci:ver25-blinkwait250-blinkon500-blinkoff450,r-cr-o:hor20"

-- character used to visually represent whitespace inserted by Vim
-- to automatically fill lines to a specific width
vim.opt.fillchars = { eob = " " }

-- show trailing whitespace
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣'}

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

-- dont show mode (insert, visual, etc) in the status line
vim.o.showmode = false

-- always show status line but only of the actual buffer
vim.o.laststatus = 3

-- highlight the current line
vim.o.cursorline = true
vim.o.cursorlineopt = "line,number"
-- vim.o.cursorlineopt = "number"

-- sign column always displayed
vim.o.signcolumn = "yes"

-- news panes are displayed right or under the actual pane
vim.o.splitbelow = true
vim.o.splitright = true

-- show matching brackets
vim.o.showmatch = true

-- text wrapping at 80 characters without breaking words
vim.opt.textwidth = 80
vim.opt.wrap = true
vim.opt.smoothscroll = true
vim.opt.linebreak = true
vim.opt.formatoptions = "jqlnt"
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:0,min:0"
vim.opt.showbreak = " ╰─ "
-- vim.opt.showbreak = " ··↪:"
-- vim.opt.showbreak = "······"
-- test:

-- store undo history
vim.opt.undofile = true

-- disable swap files
vim.opt.hidden = true
vim.opt.swapfile = true

-- sync buffers automatically between different neovim sessions
vim.opt.autoread = true

-- fast update time for events
vim.opt.updatetime = 200

-- unix line endings
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos", "mac" }
-- vim.opt.fileformats = { "unix" }
vim.opt.encoding = "utf-8"
-- vim.opt.fileencoding = "utf-8"

-- instead of splits, open in tabs when opening through quickfix
-- vim.opt.switchbuf = "newtab"

-- set the title of the terminal to the name of the file
vim.opt.title = true

-- reduce command line msgs
vim.opt.shortmess:append("WcC")

-- Reduce scroll during window split
vim.o.splitkeep = "screen"

-- set syntax highlighting if not already set
if vim.fn.exists("syntax_on") ~= 1 then
    vim.cmd([[syntax enable]])
end
