-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig

-- load all base46 highlights
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

-- base46+ui config
local M = {}
M.ui = {
theme = "rosepine",

-- hl_override = {
-- Comment = { italic = true },
-- [@comment] = { italic = true },
-- },
}

return M
