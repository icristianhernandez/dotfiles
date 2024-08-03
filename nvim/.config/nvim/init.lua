vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣'}
require("lazyload")
require("options")
require("autocmds")
vim.schedule(function()
    require("mappings")
end)
