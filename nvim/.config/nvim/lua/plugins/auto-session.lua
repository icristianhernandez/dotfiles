return {
    {
        "rmagatti/auto-session",
        lazy = false,
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,localoptions,"
            local neovide_wsl_path = "/mnt/c/Program Files/Neovide"
            local is_neovide_wsl = vim.loop.cwd() == neovide_wsl_path
            local is_linux_home = vim.loop.cwd() == vim.loop.os_homedir()

            local enable_last_session = is_linux_home or is_neovide_wsl

            -- require("auto-session").setup({
            --     -- auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
            --     -- auto_session_use_git_branch = true,
            --     auto_session_enable_last_session = enable_last_session,
            --     auto_save_enabled = true,
            --     auto_restore_enabled = true,
            --
            --     session_lens = {
            --         buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
            --         load_on_setup = true,
            --         theme_conf = { border = true },
            --         previewer = false,
            --     },
            -- })

            require("auto-session").setup({
                auto_restore = true,
                auto_restore_last_lession = enable_last_session,
                auto_save = true,

                session_lens = {
                    buftypes_to_ignore = {},
                    load_on_setup = true,
                    previewer = false,
                    theme_conf = {
                        border = true,
                    },
                },
            })

            vim.keymap.set("n", "<leader>ss", require("auto-session.session-lens").search_session, {
                noremap = true,
            })

            vim.keymap.set("n", "<leader>sd", ":Autosession delete<CR>", {
                noremap = true,
            })

            -- vim.cmd("Autosession search")
        end,
    },
}
