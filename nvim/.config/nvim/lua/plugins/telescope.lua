return {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },

    keys = {
		{ "<leader>ff", ":Telescope find_files<CR>", desc = "Find files", silent = true },
		{ "<leader>fg", ":Telescope live_grep<CR>",  desc = "Live grep",  silent = true },
		{ "<leader>fb", ":Telescope buffers<CR>",    desc = "Buffers",    silent = true },
		{ "<leader>fh", ":Telescope help_tags<CR>",  desc = "Help tags",  silent = true },
		{
			"<leader>fa",
			":Telescope find_files follow=true no_ignore=true hidden=true<CR>",
			desc = "Find files (all)",
			silent = true,
		},
	},

    config = function()
        local actions = require("telescope.actions")

        require("telescope").setup({
            defaults = {
                file_ignore_patterns = { ".git/", "node_modules/", "vendor/" },

                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                        ["<tab>"] = actions.move_selection_next,
                        ["<s-tab>"] = actions.move_selection_previous,
                    },
                    n = {
                        ["<tab>"] = actions.move_selection_next,
                        ["<s-tab>"] = actions.move_selection_previous,
                    }
                },

                layout_strategy= 'vertical',
                layout_config = {
                    prompt_position = "top",
                    preview_cutoff = 0,
                    -- center = { width = 0.7, height = 0.45, anchor = "N", },
                    -- vertical = { mirror = true, },
                },

				sorting_strategy = "ascending",
				initial_mode = "insert",               

                path_display = { "truncate", truncate = 5},

				prompt_prefix = "  ",
				selection_caret = " 󱞩  ",
				entry_prefix = " ",
                borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            }
        })
    end
}
