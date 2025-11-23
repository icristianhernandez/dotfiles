local M = {}

-- Try to obtain uname using the new vim.uv API, falling back to vim.loop
local uv = vim.uv or vim.loop
local uname = nil
if uv and type(uv.os_uname) == "function" then
    local ok, res = pcall(uv.os_uname)
    if ok and res then
        uname = res
    end
end

-- Fallback if uname couldn't be obtained
uname = uname or { sysname = "unknown", release = "" }

local sysname = (uname.sysname or ""):lower()

M.NAME = sysname
M.IS_MAC = sysname == "darwin"
M.IS_LINUX = sysname == "linux"
M.IS_WINDOWS = sysname:find("windows") ~= nil
M.IS_WSL = M.IS_LINUX and tostring(uname.release or ""):lower():find("microsoft") ~= nil

M.uname = uname

return M
