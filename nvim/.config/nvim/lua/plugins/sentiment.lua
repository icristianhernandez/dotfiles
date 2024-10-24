return {
    -- highlight the current {}, [], level.
    -- not work for other delimiters like function() end
    "utilyre/sentiment.nvim",
    version = "*",
    event = "BufRead",
    dependencies = {
        {
            -- to improve the matchparen functionality
            "monkoose/matchparen.nvim",
            opts = {},
            init = function()
                vim.g.loaded_matchparen = 1
            end,
        },
    },
    init = function()
        -- `matchparen.vim` needs to be disabled manually in case of lazy loading
        vim.g.loaded_matchparen = 1
    end,
    opts = {},
}

-- return {
--     "theHamsta/nvim-treesitter-pairs",
--     event = "BufRead",
--     lazy = true,
--
--     dependencies = {
--         -- to improve the matchparen functionality
--         {
--             "monkoose/matchparen.nvim",
--             opts = {},
--             init = function()
--                 vim.g.loaded_matchparen = 1
--             end,
--         },
--         {
--             "nvim-treesitter/nvim-treesitter",
--         },
--         {
--             "utilyre/sentiment.nvim",
--             opts = {},
--         },
--     },
--
--     config = function()
--         require("nvim-treesitter.configs").setup({
--             pairs = {
--                 enable = false,
--                 disable = {},
--                 highlight_pair_events = { "CursorMoved" },
--                 highlight_self = true,
--                 goto_right_end = false,
--             },
--             keymaps = {
--                 goto_partner = "m",
--                 delete_balanced = "X",
--             },
--         })
--     end,
-- }
