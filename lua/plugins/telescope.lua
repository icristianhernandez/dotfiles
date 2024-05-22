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
		{
			"<leader>fa",
			":Telescope find_files follow=true no_ignore=true hidden=true<CR>",
			desc = "Find files (all)",
			silent = true,
		},
	},

	config = function()
		local actions = require("telescope.actions")

      -- Display entry text after two tabs as comment.
      -- Used to display file paths as filename followed by greyed-out path.
      -- https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1873229658
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopeResults",
        callback = function(ctx)
          vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
          end)
        end,
      })
      local function filename_first_path_display(_, path)
        local tail = vim.fs.basename(path)
        local parent = vim.fs.dirname(path)
        if parent == "." then
          return tail
        else
          return string.format("%s\t\t%s", tail, parent)
        end
      end
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
				selection_caret = " 󱞩  ",
				entry_prefix = " ",
				initial_mode = "insert",

				path_display = filename_first_path_display,
				winblend = 5,
				borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				color_devicons = true,
				set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
				file_previewer = require("telescope.previewers").vim_buffer_cat.new,
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

				-- reduce results and find file width and increase width of preview
				-- also, set prompt box to top
				layout_config = {
					prompt_position = "top",
					preview_cutoff = 120,
					horizontal = { width = 0.9, height = 0.9, preview_width = 0.5 },
					vertical = { width = 0.9, height = 0.9, preview_height = 0.6 },
				},

				-- reverse the order of results (top to bottom)
				sorting_strategy = "ascending",

				-- add fzf
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			},
		})
	end,
}
