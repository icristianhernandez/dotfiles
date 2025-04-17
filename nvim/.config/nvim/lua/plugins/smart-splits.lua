return {
    -- A plugin for resizing Neovim splits more intelligently
    "mrjones2014/smart-splits.nvim",
    lazy = true,

    keys = {
        {
            "<Up>",
            "<cmd>lua require('smart-splits').resize_up()<CR>",
            { noremap = true, silent = true, desc = "Resize split up" },
        },
        {
            "<Down>",
            "<cmd>lua require('smart-splits').resize_down()<CR>",
            { noremap = true, silent = true, desc = "Resize split down" },
        },
        {
            "<Left>",
            "<cmd>lua require('smart-splits').resize_left()<CR>",
            { noremap = true, silent = true, desc = "Resize split left" },
        },
        {
            "<Right>",
            "<cmd>lua require('smart-splits').resize_right()<CR>",
            { noremap = true, silent = true, desc = "Resize split right" },
        },
    },

    opts = {},
}
