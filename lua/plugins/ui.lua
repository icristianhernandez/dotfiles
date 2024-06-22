return {
	{
		-- for light mode
		"folke/tokyonight.nvim",
		event = "VimEnter",
	},
	{
		"Mofiqul/vscode.nvim",
		event = "VimEnter",
	},
	{
		"numToStr/Sakura.nvim",
		event = "VimEnter",
	},
	{
		-- for dark mode
		"catppuccin/nvim",
		event = "VimEnter",
	},
	{
		"navarasu/onedark.nvim",
		event = "VimEnter",
	},
	{
		-- sneak of the line when doing :50g, for example
		"nacro90/numb.nvim",
		event = "BufRead",
		opts = {},
	},

	{
		-- for changing some uis
		"stevearc/dressing.nvim",
		event = "UIEnter",
		opts = {},
	},

	-- {
	-- 	"rmagatti/goto-preview",
	-- 	opts = {
	-- 		default_mappings = false
	-- 	},
	-- },

	-- {
	-- 	-- scroll bar at the right of the screen
	-- 	"dstein64/nvim-scrollview",
	-- 	event = "BufRead",
	-- 	opts = {},
	-- },

	{
		"shortcuts/no-neck-pain.nvim",
		opts = {
			width = 90,

			-- autocmds = {
			-- 	enableOnVimEnter = true,
			-- 	reloadOnColorSchemeChange = true,
			-- },

			mappings = {
				enable = true,
				toggle = "<leader>z",
			},
		},
	},

	{
		"folke/which-key.nvim",
		event = "VimEnter",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {},
	},

	{
		"f-person/auto-dark-mode.nvim",
		priority = 1000,
		config = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.cmd("colorscheme onedark")
			end,
			set_light_mode = function()
				vim.cmd("colorscheme tokyonight-day")
			end,
		},
	},

	{
		"numToStr/FTerm.nvim",
		opts = {},
		config = function()
			vim.api.nvim_create_user_command("FTermToggle", require("FTerm").toggle, { bang = true })
			vim.api.nvim_set_keymap("n", "<C-o>", "<cmd>FTermToggle<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("t", "<C-o>", "<C-\\><C-n><cmd>FTermToggle<CR>", { noremap = true, silent = true })
		end,
	},

	-- {
	-- 	"folke/noice.nvim",
	-- 	dependencies = {
	-- 		"MunifTanjim/nui.nvim",
	-- 	},
	-- 	opts = {
	-- 		messages = {
	-- 			enabled = false,
	-- 		},
	-- 		popupmenu = {
	-- 			enabled = false,
	-- 		},
	-- 		notify = {
	-- 			enabled = false,
	-- 		},
	-- 		lsp = {
	-- 			progress = {
	-- 				enabled = false,
	-- 			},
	-- 			message = {
	-- 				enabled = false,
	-- 			},
	-- 		},
	-- 		presets = {
	-- 			bottom_search = true,
	-- 			lsp_doc_border = false,
	-- 		},
	-- 	},
	-- },

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({
				indent = {
					char = "▏",
				},
				scope = {
					show_start = false,
					show_end = false,
				},
				exclude = {
					-- filetypes =,
					buftypes = { "terminal" },
				},
			})
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		event = "User FilePost",
		opts = { user_default_options = { names = false } },
		config = function(_, opts)
			require("colorizer").setup(opts)

			-- execute colorizer as soon as possible
			vim.defer_fn(function()
				require("colorizer").attach_to_buffer(0)
			end, 0)
		end,
	},

	-- {
	-- 	-- fade inactive windows
	-- 	"TaDaa/vimade",
	-- },

	{
		"nvimdev/hlsearch.nvim",
		event = "BufRead",
		opts = {},
	},

	{
		"hiphish/rainbow-delimiters.nvim",
		event = "BufRead",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
		end,
	},

	{
		"utilyre/sentiment.nvim",
		version = "*",
		event = "VeryLazy", -- keep for lazy loading
		opts = {
			-- config
		},
		init = function()
			-- `matchparen.vim` needs to be disabled manually in case of lazy loading
			vim.g.loaded_matchparen = 1
		end,
	},
}
