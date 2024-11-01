require("options")

vim.schedule(function()
    require("mappings")
end)

vim.schedule(function()
    require("user_commands")
end)

require("autocmds")

if vim.g.neovide then
    require("neovide-options")
end

require("lazyload")
