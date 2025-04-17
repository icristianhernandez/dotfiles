return {
    -- nvim-treesitter: An incremental parsing system for programming tools (create a tree of the code nodes, etc)
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-context",
            opts = {
                -- Avoid the sticky context from growing a lot.
                max_lines = 1,
                -- Match the context lines to the source code.
                multiline_threshold = 1,
                -- Disable it when the window is too small.
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
        { "<c-space>", false },
        { "<CR>", desc = "Increment Selection", mode = { "x", "n" } },
        { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
}
