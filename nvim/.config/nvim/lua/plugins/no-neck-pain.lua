return {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    lazy = false,
    config = function()
        require("no-neck-pain").setup({
            width = 90,
            autocmds = {
                -- enableOnVimEnter = true,
            },
        })

        vim.api.nvim_set_keymap(
            "n",
            "<leader>un",
            "<cmd>lua require('no-neck-pain').toggle()<cr>",
            { noremap = true, silent = true }
        )
    end,
}
