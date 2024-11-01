local uname = vim.loop.os_uname()
_G.OS = uname.sysname
_G.IS_MAC = OS == "Darwin"
_G.IS_LINUX = OS == "Linux"
_G.IS_WINDOWS = OS:find("Windows") and true or false
_G.IS_WSL = IS_LINUX and uname.release:lower():find("microsoft") and true or false

require("options")

vim.schedule(function()
    require("mappings")
end)

vim.schedule(function()
    require("user_commands")
end)

require("autocmds")

if vim.g.neovide then
    require("neovide")
end

if _G.IS_WSL then
    require("wsl")
end

require("lazyload")
