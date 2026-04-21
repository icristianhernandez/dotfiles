vim.pack.add({
    "https://github.com/kristijanhusak/vim-dadbod-ui",
    "https://github.com/tpope/vim-dadbod",
})

vim.g.db_ui_use_nerd_fonts = 1
vim.g.dbs = {
    {
        name = "supabase-local",
        url = "postgresql://postgres:postgres@127.0.0.1:54322/postgres?sslmode=disable",
    },
}

vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Toggle Database UI" })
