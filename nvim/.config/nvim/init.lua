local uname = vim.uv.os_uname()
local sysname = uname.sysname:lower()

_G.OS = sysname
_G.IS_MAC = sysname == "darwin"
_G.IS_LINUX = sysname == "linux"
_G.IS_WINDOWS = sysname:find("windows") ~= nil
_G.IS_WSL = _G.IS_LINUX and uname.release:lower():find("microsoft") ~= nil

if vim.g.neovide then
    require("config.neovide")
end

if _G.IS_WSL then
    require("config.wsl")
end

require("config.lazy")
