return {
    "andymass/vim-matchup",
    opts = function(_, opts)
        -- vim.g.matchup_matchparen_offscreen = { method = "none" }
        -- vim.g.matchup_transmute_enabled = 1
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
        vim.g.matchup_matchparen_deferred = 1

        vim.g.matchup_matchparen_hi_surround_always = 0
        Snacks.toggle({
            name = "Matchup Hi Surround",
            get = function()
                return vim.g.matchup_matchparen_hi_surround_always == 1
            end,
            set = function(state)
                vim.g.matchup_matchparen_hi_surround_always = state and 1 or 0
            end,
        }):map("<leader>uH")

        vim.keymap.set(
            "n",
            "<leader>ci",
            "<plug>(matchup-hi-surround)",
            { desc = "Highlight actual surround", silent = true }
        )

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
