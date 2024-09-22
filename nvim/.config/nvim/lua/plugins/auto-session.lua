return {
    {
        "rmagatti/auto-session",
        lazy = false,
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,localoptions,"
            local is_cwd_home = vim.fn.getcwd() == vim.loop.os_homedir()

            require("auto-session").setup({
                auto_restore = true,
                auto_restore_last_session = is_cwd_home,
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
