return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},

	keys = {
		{ "<leader>ff", ":Telescope find_files<CR>", desc = "Find files", silent = true },
		{ "<leader>fg", ":Telescope live_grep<CR>", desc = "Live grep", silent = true },
		{ "<leader>fb", ":Telescope buffers<CR>", desc = "Buffers", silent = true },
		{ "<leader>fh", ":Telescope help_tags<CR>", desc = "Help tags", silent = true },
	},

	config = function()
		local actions = require("telescope.actions")

		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<esc>"] = actions.close,
					},
				},

				vimgrep_arguments = {
					"rg",
					"-L",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
				prompt_prefix = "  ",
				selection_caret = " ",
				entry_prefix = " ",
				initial_mode = "insert",
				selection_strategy = "reset",
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
					width = 0.87,
					height = 0.80,
					preview_cutoff = 120,
				},

				-- news
				path_display = { "truncate" },
				winblend = 0,
				borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				color_devicons = true,
				set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			},
		})
	end,
}
