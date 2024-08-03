-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig

-- base46+ui config
local M = {}

M.ui = {
	theme = "rosepine-dawn",

	statusline = {
		theme = "vscode_colored",

		modules = {
			-- file_modified = function()
			-- 	-- return vim.bo.modified and "%#St_file#%#St_file_sep#" or ""
			--      return vim.bo.modified and "[]" or ""
			-- end,

			file_modified = "%m ",
			empty_space = " ",
		},

		-- order = {"mode", "file","file_modified", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cursor", "cwd" },
		order = { "mode", "file", "file_modified", "%=", "lsp_msg", "%=", "diagnostics", "git", "empty_space", "cwd" },

	},

	tabufline = {
		enabled = false,
	}
}

return M
