return {
    "andymass/vim-matchup",
    lazy = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        vim.g.matchup_matchparen_offscreen = { method = "none" }

        -- for tags values, parallel change the tag when typing
        vim.g.matchup_transmute_enabled = 1

        -- always highlight the current surrounding pair
        vim.g.matchup_matchparen_deferred = 1 -- needed dependency
        vim.g.matchup_matchparen_hi_surround_always = 1
        -- for instant highlight but laggy
        -- vim.g.matchup_matchparen_deferred_show_delay = 0 
       vim.g.matchup_matchparen_deferred_hide_delay = 150


        -- treesitter support
        require("nvim-treesitter.configs").setup {
            matchup = {
                enable = true,
            },
        }
    end,
}
