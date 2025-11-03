return {
    -- lukas-reineke/indent-blankline.nvim: show indent guides and scope
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "▏",
                tab_char = "▏",
                smart_indent_cap = true,
                repeat_linebreak = true,
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = true,
            },
        },
    },

    -- HiPhish/rainbow-delimiters.nvim: color nested delimiters by depth
    {
        "HiPhish/rainbow-delimiters.nvim",
        -- nvim-treesitter/nvim-treesitter: incremental parsing and AST-based features
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        lazy = true,
        event = "BufReadPre",
    },

    {
        "folke/snacks.nvim",
        event = "VeryLazy",
        ---@type snacks.Config
        opts = {
            scroll = { enabled = true },
        },
    },
}
