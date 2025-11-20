-- Coding helpers and text manipulation plugins
return {
    -- altermo/ultimate-autopair.nvim: Automatic pairing of brackets, quotes, etc.
    {
        "altermo/ultimate-autopair.nvim",
        lazy = true,
        event = { "InsertEnter", "CmdlineEnter" },

        opts = {
            space = {
                -- That can be changed in the future bc it's a good option
                enable = false,
            },
        },
    },

    -- kylechui/nvim-surround: Surround text objects with pairs of characters
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",

        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    visual = "ñ",
                },
            })
        end,
    },

    -- abecodes/tabout.nvim: Exit from insert mode contexts easily
    {
        "abecodes/tabout.nvim",
        lazy = true,

        keys = {
            { "<c-x>", "<Plug>(TaboutMulti)", mode = { "i", "n" }, silent = true },
            { "<c-z>", "<Plug>(TaboutBackMulti)", mode = { "i", "n" }, silent = true },
        },

        opts = {
            tabkey = "",
            backwards_tabkey = "",
            act_as_tab = false,
        },
    },

    -- echasnovski/mini.splitjoin: Split or join arguments across multiple lines
    {
        "echasnovski/mini.splitjoin",
        lazy = true,

        keys = {
            { "gs" },
        },

        opts = {
            mappings = {
                toggle = "gs",
            },
        },
    },

    -- echasnovski/mini.move: Move visual selections between lines
    {
        "echasnovski/mini.move",
        lazy = true,

        keys = {
            { "<S-h", modes = "v" },
            { "<S-l", modes = "v" },
            { "<S-j", modes = "v" },
            { "<S-k", modes = "v" },
        },

        opts = {
            mappings = {
                -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                left = "<S-h>",
                right = "<S-l>",
                down = "<S-j>",
                up = "<S-k>",
            },
        },
    },

    -- RRethy/nvim-treesitter-endwise: Automatically add 'end' to blocks
    {
        "RRethy/nvim-treesitter-endwise",
        event = { "InsertEnter" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- m4xshen/hardtime.nvim: Help break bad Vim habits
    {
        "m4xshen/hardtime.nvim",
        lazy = false,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            restricted_keys = {
                ["k"] = false,
                ["j"] = false,
            },
        },
    },
}
