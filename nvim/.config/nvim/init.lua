vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

require("options")

vim.schedule(function()
    require("mappings")
end)

require("autocmds")

if vim.g.neovide then
    require("neovide-options")
end

require("lazyload")
