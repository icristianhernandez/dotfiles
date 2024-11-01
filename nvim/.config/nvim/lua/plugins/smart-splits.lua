local resize_ammount = 3

return {
    "mrjones2014/smart-splits.nvim",
    -- A plugin for resizing Neovim splits more intelligently
    lazy = false,
    config = function()
        require("smart-splits").setup({})
        -- keybindings
        vim.api.nvim_set_keymap(
            "n",
            "<Up>",
            "<cmd>lua require('smart-splits').resize_up()<CR>",
            { noremap = true, silent = true, desc = "Resize split up" }
        )
        vim.api.nvim_set_keymap(
            "n",
            "<Down>",
            "<cmd>lua require('smart-splits').resize_down()<CR>",
            { noremap = true, silent = true, desc = "Resize split down" }
        )
        vim.api.nvim_set_keymap(
            "n",
            "<Left>",
            "<cmd>lua require('smart-splits').resize_left()<CR>",
            { noremap = true, silent = true, desc = "Resize split left" }
        )
        vim.api.nvim_set_keymap(
            "n",
            "<Right>",
            "<cmd>lua require('smart-splits').resize_right()<CR>",
            { noremap = true, silent = true, desc = "Resize split right" }
        )
    end,
}
