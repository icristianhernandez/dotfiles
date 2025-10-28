return {
    -- nvim-treesitter/nvim-treesitter: incremental parsing, highlighting and AST-powered features
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            -- nvim-treesitter/nvim-treesitter-context: show current context (function/class) at top
            {
                "nvim-treesitter/nvim-treesitter-context",
                opts = {
                    max_lines = 1,
                    multiline_threshold = 1,
                    min_window_height = 20,
                },
            },
        },
        opts = {
            auto_install = true,
            sync_install = true,
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<bs>",
                },
            },
        },
        keys = {
            { "<CR>", desc = "Increment Selection", mode = { "x", "n" } },
            { "<bs>", desc = "Decrement Selection", mode = "x" },
        },
    },
}
