return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	lazy = true,

	keys = {
		{ "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle tree", silent = true },
	},

	-- opts = {
	-- 	view = {
	-- 		side = "center",
	-- 		float = {
	-- 			enable = true,
	-- 		},
	-- 	},
	-- 	actions = {
	-- 		open_file = {
	-- 			quit_on_open = true,
	-- 			resize_window = true, -- Optional: Resize window after opening file
	-- 		},
	-- 	},
	-- },

	config = function()
		require("nvim-tree").setup({
			disable_netrw = true,
			hijack_netrw = true,
			respect_buf_cwd = true,
			sync_root_with_cwd = true,

			actions = {
				open_file = {
					quit_on_open = true,
				},
			},

			update_focused_file = {
				enable = true,
				update_cwd = true,
			},
		})
	end,
}
