return {
    "andymass/vim-matchup",
    opts = function(opts)
        -- vim.g.matchup_matchparen_offscreen = { method = "none" }
        -- vim.g.matchup_transmute_enabled = 1
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
        vim.g.matchup_matchparen_stopline = vim.o.lines * 3
        vim.g.matchup_matchparen_deferred = 1

        -- use one of both
        vim.g.matchup_matchparen_hi_surround_always = 1
        -- vim.keymap.set("n", "<leader>ci", "<plug>(matchup-hi-surround)", { silent = true })

        return opts
    end,

    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter",
            opts = {
                matchup = {
                    enable = true,
                },
            },
        },
    },
}
