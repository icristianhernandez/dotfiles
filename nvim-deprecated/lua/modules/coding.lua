return {
    -- echasnovski/mini.splitjoin: toggle and transform code between single/multi-line forms
    {
        "echasnovski/mini.splitjoin",
        lazy = true,
        keys = { { "gs" } },
        opts = { mappings = { toggle = "gs" } },
    },

    -- echasnovski/mini.move: move lines, blocks and selections easily
    {
        "echasnovski/mini.move",
        lazy = true,
        keys = {
            { "<S-h>", modes = "v" },
            { "<S-l>", modes = "v" },
            { "<S-j>", modes = "v" },
            { "<S-k>", modes = "v" },
        },
        opts = {
            mappings = {
                left = "<S-h>",
                right = "<S-l>",
                down = "<S-j>",
                up = "<S-k>",
            },
        },
    },

    -- kylechui/nvim-surround: add/change/delete surrounding delimiters (quotes, brackets)
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({ keymaps = { visual = "ñ" } })
        end,
    },

    -- folke/ts-comments.nvim: toggle and manage comments using Treesitter
    {
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- altermo/ultimate-autopair.nvim: smart autopairs for brackets, quotes and spacing
    {
        "altermo/ultimate-autopair.nvim",
        lazy = true,
        event = { "InsertEnter", "CmdlineEnter" },
        opts = { space = { enable = true } },
    },

    -- RRethy/nvim-treesitter-endwise: auto add 'end' in end-style block languages
    {
        "RRethy/nvim-treesitter-endwise",
        event = { "InsertEnter" },
        -- nvim-treesitter/nvim-treesitter: incremental parsing and AST-based features
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- windwp/nvim-ts-autotag: auto-close and rename HTML/JSX tags using Treesitter
    {
        "windwp/nvim-ts-autotag",
        event = { "InsertEnter" },
        -- nvim-treesitter/nvim-treesitter: incremental parsing and AST-based features
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {},
    },

    -- m4xshen/hardtime.nvim: enforce efficient editing habits by restricting keys
    {
        "m4xshen/hardtime.nvim",
        lazy = false,
        -- MunifTanjim/nui.nvim: UI component library used by plugins
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            restricted_keys = {
                ["k"] = false,
                ["j"] = false,
                ["<Up>"] = false,
                ["<Down>"] = false,
                ["<Left>"] = false,
                ["<Right>"] = false,
            },
        },
    },
}
