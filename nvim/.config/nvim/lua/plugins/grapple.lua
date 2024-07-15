return {
	"cbochs/grapple.nvim",
	dependencies = { "nvim-web-devicons" },
	opts = {
		scope = "git", -- also try out "git_branch"
		icons = true, -- setting to "true" requires "nvim-web-devicons"
		status = false,
	},
	keys = {
		{ "<leader>ha", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
		{ "<leader>hh", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },

		{ "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
		{ "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
		{ "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
		{ "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },

		{ "<leader>hr", "<cmd>Grapple untag<cr>", desc = "Remove tag" },
		{ "<leader>hR", "<cmd>Grapple reset<cr>", desc = "Remove all tags"},

		{ "<leader>hn", "<cmd>Grapple next<cr>", desc = "Next tag" },
		{ "<leader>hp", "<cmd>Grapple prev<cr>", desc = "Previous tag" },
	},
}
