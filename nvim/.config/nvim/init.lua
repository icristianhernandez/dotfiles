vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- require("options")
require("lazyload")
require("nvchad.autocmds")
vim.schedule(function()
    require("mappings")
end)
