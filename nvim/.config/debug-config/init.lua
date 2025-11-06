-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader>ff", ":find ", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ee", "<cmd>Ex<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>qq", "<cmd>q!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", { noremap = true, silent = true })

-- Minimal plugin setup with the two plugins we want to test.
-- Configs are minimal copies of the settings in modules/editor.lua.
require("lazy").setup({
	spec = {
		{
			"rmagatti/auto-session",
			lazy = false,
			init = function()
				vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,"
			end,

			---@module "auto-session"
			---@type AutoSession.Config
			opts = {
				git_use_branch_name = true,
				git_auto_restore_on_branch_change = true,
				auto_restore_last_session = vim.fn.getcwd() == vim.fn.expand("~")
					and vim.fn.argc() == 0
					and (#vim.api.nvim_list_uis() > 0),
				cwd_change_handling = true,
				continue_restore_on_error = true,
			},

			keys = {
				{ "<leader>fs", "<cmd>AutoSession search<CR>", { noremap = true, desc = "Search session" } },
				{ "<leader>fS", "<cmd>AutoSession deletePicker<CR>", { noremap = true, desc = "Delete sessions" } },
			},
		},

		{
			-- ThePrimeagen/harpoon: quick file bookmarking and navigation
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },

			opts = {
				menu = { width = vim.api.nvim_win_get_width(0) - 4 },
				settings = {
					save_on_toggle = true,
					sync_on_ui_close = true,
				},
			},

			keys = function()
				local harpoon = require("harpoon")

				local keys = {
					{
						"<leader>H",
						function()
							harpoon:list():add()
						end,
						desc = "Harpoon Current File",
					},
					{
						"<leader>h",
						function()
							harpoon.ui:toggle_quick_menu(harpoon:list())
						end,
						desc = "Harpoon Quick Menu",
					},
				}
				for i = 1, 9 do
					table.insert(keys, {
						"<leader>" .. i,
						function()
							harpoon:list():select(i)
						end,
						desc = "Harpoon to File " .. i,
					})
				end
				return keys
			end,

			config = function(_, opts)
				require("harpoon"):setup(opts)
			end,
		},
	},
})
