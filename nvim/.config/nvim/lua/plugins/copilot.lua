return {
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",

		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<C-f>",
						accept_word = false,
						-- accept_line = "<C-F>",
						next = "<M-}>",
						prev = "<M-{>",
						dismiss = "<C-}>",
					},
				},
			})
		end,
	},
}
