return {
	{
		"rmagatti/auto-session",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			vim.o.sessionoptions =
				"blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,resize"

			require("auto-session").setup({
				-- auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
				auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
				auto_save_enabled = true,
				auto_restore_enabled = true,
				-- auto_session_use_git_branch = true,

				session_lens = {
					buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
					load_on_setup = true,
					theme_conf = { border = true },
					previewer = false,
				},
			})

			vim.keymap.set("n", "<leader>fs", require("auto-session.session-lens").search_session, {
				noremap = true,
			})

			vim.keymap.set("n", "<leader>sd", ":Autosession delete<CR>", {
				noremap = true,
			})

			-- vim.cmd("Autosession search")
		end,
	},
}
