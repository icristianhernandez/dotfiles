vim.pack.add({
    "https://github.com/rmagatti/auto-session",
})

vim.o.sessionoptions = "blank,buffers,folds,curdir,help,tabpages,terminal,localoptions"

require("auto-session").setup({
    git_use_branch_name = true,
    git_auto_restore_on_branch_change = true,
    cwd_change_handling = true,
    auto_restore_last_session = vim.fn.getcwd() == vim.fn.expand("~")
        and vim.fn.argc() == 0
        and (#vim.api.nvim_list_uis() > 0),
    continue_restore_on_error = true,
})

vim.keymap.set("n", "<leader>ss", "<cmd>AutoSession search<CR>", { noremap = true, desc = "Search session" })
vim.keymap.set("n", "<leader>sS", "<cmd>AutoSession deletePicker<CR>", { noremap = true, desc = "Delete sessions" })
