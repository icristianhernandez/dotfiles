local uname = (vim.loop["os_uname"] and vim.loop["os_uname"]())
local sysname = uname.sysname:lower()

_G.OS = sysname
_G.IS_MAC = sysname == "darwin"
_G.IS_LINUX = sysname == "linux"
_G.IS_WINDOWS = sysname:find("windows") ~= nil
_G.IS_WSL = _G.IS_LINUX and uname.release:lower():find("microsoft") ~= nil

require("core.options")
require("core.keymaps")
require("core.autocmds")

if vim.g.neovide then
    require("core.neovide")
end

if _G.IS_WSL then
    require("core.wsl")
end

require("core.lazy-setup")
