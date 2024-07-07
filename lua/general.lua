-- use system clipboard
-- vim.opt.clipboard = "unnamedplus"

-- change identation to 4 spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- True color
vim.o.termguicolors = true

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- show line numbers
vim.opt.number = true
vim.opt.numberwidth = 5

-- Enable mouse mode
vim.o.mouse = "a"

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Incremental live completion
vim.opt.inccommand = "split"

-- determines the number of lines above and below the cursor that
-- remain visible even when scrolling
vim.opt.scrolloff = 7

-- character used to visually represent whitespace inserted by Vim
-- to automatically fill lines to a specific width
vim.opt.fillchars = { eob = " " }

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
vim.opt.linebreak = true
vim.opt.formatoptions = "jcroqlnt"
vim.opt.breakindent = true
-- vim.opt.breakindentopt = "shift:1,min:0"
vim.opt.showbreak = "↪:::"

-- store undo history
vim.opt.undofile = true

-- disable swap files
vim.opt.hidden = false

-- float transparency
vim.opt.pumblend = 20

-- window transparency
vim.opt.winblend = 10

-- fast update time for events
vim.opt.updatetime = 100

-- Disable highlight signs color
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	pattern = { "*" },
	callback = function()
		vim.cmd("hi clear SignColumn")
	end,
})

-- Auto insert when enter a terminal window
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
	pattern = { "*" },
	callback = function()
		if vim.opt.buftype:get() == "terminal" then
			vim.cmd(":startinsert")
		end
	end,
})

-- -- disable auto comment
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "*" },
	callback = function()
		vim.opt_local.formatoptions:remove("c")
		vim.opt_local.formatoptions:remove("r")
		vim.opt_local.formatoptions:remove("o")
	end,
})

