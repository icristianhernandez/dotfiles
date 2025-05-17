-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,localoptions,"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,"

return {
    -- auto-session: auto save and restore sessions, with a custom auto restore
    -- at start
    "rmagatti/auto-session",
    lazy = false,

    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        bypass_save_filetypes = { "alpha", "dashboard" },
        git_use_branch_name = true,
        auto_restore_last_session = vim.fn.getcwd() == vim.fn.expand("~")
            and vim.fn.argc() == 0
            and (#vim.api.nvim_list_uis() > 0),
        cwd_change_handling = true,
        continue_restore_on_error = true,
    },
    keys = {
        {
            "<leader>fs",
            "<cmd>Autosession search<CR>",
            { noremap = true, desc = "Search session" },
        },
        {
            "<leader>fS",
            "<cmd>Autosession delete<CR>",
            { noremap = true, desc = "Delete sessions" },
        },
    },
}
