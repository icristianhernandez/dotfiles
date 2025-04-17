-- lazyvim configs:
vim.g.ai_cmp = false

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- use independent clipboard for neovim
if vim.fn.has("wsl") == 1 then
    -- I need to define the clipboard in both api because Lazyvim implement an
    -- lazyload for basic nvim configs and that crash/don't init my clipboard
    -- settings
    -- setting culprits: https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/config/init.lua#L170
    local wsl_clipboard_provider = {
        name = "WslClipboard",
        copy = {
            ["+"] = "clip.exe",
            ["*"] = "clip.exe",
        },
        paste = {
            ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }

    vim.g.clipboard = wsl_clipboard_provider
    vim.opt.clipboard = wsl_clipboard_provider
else
    vim.g.clipboard = nil -- Ensure no clipboard override outside WSL
end

-- True color
vim.opt.termguicolors = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- set shell to fish if available
if vim.fn.executable("fish") == 1 then
    vim.opt.shell = "fish"
end

-- change indentation to 4 spaces
vim.opt.tabstop = 4
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
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- determines the number of lines above and below the cursor that remain visible even when scrolling
vim.opt.scrolloff = 7

-- blink cursor
vim.opt.guicursor = "i-ci:ver25-blinkwait250-blinkon500-blinkoff450,r-cr-o:hor20"

-- cmp ui (no)transparency
vim.opt.pumblend = 1

-- character used to visually represent whitespace inserted by Vim
vim.opt.fillchars = { eob = " " }

-- go to previous/next line with h,l,left arrow and right arrow when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

-- don't show mode (insert, visual, etc) in the status line
vim.opt.showmode = false

-- always show status line but only of the actual buffer
vim.opt.laststatus = 3

-- highlight the current line
vim.opt.cursorline = true
vim.opt.cursorlineopt = { "line", "number" }

-- sign column always displayed
vim.opt.signcolumn = "yes"
vim.opt.statuscolumn = ""

-- new panes are displayed right or under the actual pane
vim.opt.splitbelow = true
vim.opt.splitright = true

-- disable relative numbers
vim.opt.relativenumber = false

-- show matching brackets
vim.opt.showmatch = true

-- text wrapping at 80 characters without breaking words
vim.opt.textwidth = 80
vim.opt.wrap = true
vim.opt.smoothscroll = true
vim.opt.linebreak = true -- Wrap lines at convenient points
vim.opt.formatoptions = "jqlnt"
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:0,min:0"
-- vim.opt.showbreak = " >"
vim.opt.showbreak = " ↪"

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
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- set the title of the terminal to the name of the file
vim.opt.title = true

-- reduce command line msgs
vim.opt.shortmess:append("WcC")

-- Reduce scroll during window split
vim.opt.splitkeep = "screen"
