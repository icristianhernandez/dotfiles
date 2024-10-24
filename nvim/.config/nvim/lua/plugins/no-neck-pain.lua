return {
    -- no-neck-pain: center the buffer
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    lazy = false,
    config = function()
        require("no-neck-pain").setup({
            width = 90,
            autocmds = {
                enableOnVimEnter = true,
            },
        })

        vim.api.nvim_set_keymap(
            "n",
            "<leader>uc",
            "<cmd>lua require('no-neck-pain').toggle()<cr>",
            { noremap = true, silent = true, desc = "Center the buffer" }
        )
        vim.api.nvim_set_keymap(
            "n",
            "<leader>uC",
            "<cmd>lua require('no-neck-pain').resize(90)<cr>",
            { noremap = true, silent = true, desc = "Center the buffer" }
        )
    end,
}
