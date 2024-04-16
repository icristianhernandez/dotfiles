return {
	-- lazyloads all when enter insert mode
	{
		-- autopairing of (){}[] etc
		"windwp/nvim-autopairs",
		event = "InsertEnter",

		opts = {
			fast_wrap = {},
			disable_filetype = { "TelescopePrompt", "vim" },
		},

		config = function(_, opts)
			require("nvim-autopairs").setup(opts)

			-- setup cmp for autopairs
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	{
		-- lua, ruby, julia, etc (for ends delimites, etc)
		"RRethy/nvim-treesitter-endwise",
		event = "InsertEnter",

		config = function()
			require("nvim-treesitter.configs").setup({
				endwise = {
					enable = true,
				},
			})
		end,
	},

	{
		-- <>, "", '', etc
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-treesitter.configs").setup({
				autotag = {
					enable = true,
				},
			})
		end,
	},
}
