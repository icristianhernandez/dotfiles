return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufRead",

    config = function()
        require("nvim-treesitter.configs").setup({
            auto_install = true,
            sync_install = true,

            highlight = {
                enable = true,
                use_languagetree = true,
            },
            indent = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    -- selection with enter
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
