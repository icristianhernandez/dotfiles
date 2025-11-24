vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<space>")

-- -- use independent clipboard for neovim
-- if vim.fn.has("wsl") == 1 then
--     local wsl_clipboard_provider = {
--         name = "WslClipboard",
--         copy = {
--             ["+"] = "clip.exe",
--             ["*"] = "clip.exe",
--         },
--         paste = {
--             ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--             ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--         },
--         cache_enabled = 0,
--     }
--
--     vim.g.clipboard = wsl_clipboard_provider
--     vim.opt.clipboard = "unnamedplus"
-- end

-- True color
vim.opt.termguicolors = true

-- Enable mouse mode
vim.opt.mouse = "a"

-- -- set shell to fish if available
-- if vim.fn.executable("fish") == 1 then
--     vim.opt.shell = "fish"
-- else
--     vim.opt.shell = vim.o.shell or "sh"
-- end

-- change indentation to 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- show line numbers
vim.opt.number = true
vim.opt.numberwidth = 4

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- determines the number of lines above and below the cursor that remain visible even when scrolling
vim.opt.scrolloff = 7
-- detemines the horizontal off scrolling
vim.opt.sidescrolloff = 8

-- blink cursor in insert mode
vim.opt.guicursor = "i-ci-c-t:ver25-blinkwait250-blinkon500-blinkoff450,r-cr-o:hor20"

-- cmp ui (no) transparency
vim.opt.pumblend = 0

-- maximum number of entries in the popup menu
vim.opt.pumheight = 5

-- builtin completion menu behavior
vim.opt.completeopt:append({ "menuone", "noselect", "popup" })

-- minimum width for current window
vim.winminwidth = 10

-- -- character used to visually represent whitespace inserted by Vim
-- vim.opt.fillchars = { eob = " " }
vim.opt.list = true
vim.opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
}

-- go to previous/next line with h,l,left arrow and right arrow when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

-- don't show mode (insert, visual, etc) in the status line
vim.opt.showmode = false

-- always show status line but only of the actual buffer
vim.opt.laststatus = 3

-- ensure tabline is visible (avoid mutating this option during statusline draws)
vim.o.showtabline = 1

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

-- -- show matching brackets
-- vim.opt.showmatch = true

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
vim.opt.undolevels = 10000

-- don't discard changes of unloaded buffers
vim.opt.hidden = true

-- disable swap files
vim.opt.swapfile = false

-- sync buffers automatically between the loaded buffers and the externally
-- changed file
vim.opt.autoread = true

-- fast update time for events
vim.opt.updatetime = 100

-- unix line endings
vim.opt.fileformats = { "unix", "dos", "mac" }

-- -- the next is to format all to unix
-- vim.opt.fileformats = { "unix" }
-- -- the next is to force an specific encoding
-- vim.opt.fileencoding = "utf-8"

-- set the title of the terminal to the name of the file
-- vim.opt.title = true

-- reduce command line msgs
vim.opt.shortmess:append("WcC")

-- Reduce scroll during window split
vim.opt.splitkeep = "screen"

-- Confirm to save changes before exiting modified buffer
vim.opt.confirm = true

-- Clean up jumplist to avoid clutter
vim.opt.jumpoptions = "clean"
