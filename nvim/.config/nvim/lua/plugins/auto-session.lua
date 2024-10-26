return {
    -- auto-session: Auto save and restore sessions and last session
    "rmagatti/auto-session",
    lazy = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
        -- {
        --     "<leader>fs",
        --     require("auto-session.session-lens").search_session,
        --     { noremap = true, desc = "Search session" },
        -- },

        {
            "<leader>fs",
            "<cmd>lua require('auto-session.session-lens').search_session()<CR>",
            { noremap = true, desc = "Search session" },
        },

        { "<leader>fS", "<cmd>Autosession delete<CR>", { noremap = true, desc = "Delete session" } },

        { "<leader>us", "<cmd>SessionSave<CR>", { noremap = true, desc = "Save session" } },
    },

    config = function()
        vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,localoptions,"
        -- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,"
        local is_cwd_home = vim.fn.getcwd() == vim.loop.os_homedir()

        require("auto-session").setup({
            auto_restore = true,
            auto_restore_last_session = is_cwd_home,
            auto_save = true,
            auto_create = false,

            session_lens = {
                buftypes_to_ignore = {},
                load_on_setup = true,
                previewer = false,
                theme_conf = {
                    border = true,
                },
            },
        })

        -- vim.cmd("Autosession search")
    end,
}
