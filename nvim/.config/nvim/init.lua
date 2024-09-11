require("options")

vim.schedule(function()
    require("mappings")
end)

require("autocmds")

if vim.g.neovide then
    require("neovide-options")
end

require("lazyload")
