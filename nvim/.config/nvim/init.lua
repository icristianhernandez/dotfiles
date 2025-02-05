local uname = vim.loop.os_uname()
_G.OS = uname.sysname
_G.IS_MAC = _G.OS == "Darwin"
_G.IS_LINUX = _G.OS == "Linux"
_G.IS_WINDOWS = string.find(_G.OS, "Windows") and true or false
_G.IS_WSL = _G.IS_LINUX and string.find(uname.release:lower(), "microsoft") and true or false

if vim.g.neovide then
  require("config.neovide")
end

if _G.IS_WSL then
  require("config.wsl")
end

require("config.lazy")
