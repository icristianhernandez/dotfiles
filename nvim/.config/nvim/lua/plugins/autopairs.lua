return {
    {
        -- autopairing of (){}[] etc
        "windwp/nvim-autopairs",
        event = "InsertEnter",

        dependencies = {
            { "hrsh7th/nvim-cmp" },
        },

        config = function()
            require("nvim-autopairs").setup({
                fast_wrap = {},
                disable_filetype = { "TelescopePrompt", "vim" },
            })

            -- setup cmp for autopairs
            -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            -- require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    {
        -- lua, ruby, julia, etc (for ends delimiters, etc)
        "RRethy/nvim-treesitter-endwise",
        event = "InsertEnter",

        dependencies = {
            { "nvim-treesitter/nvim-treesitter" },
        },

        config = function()
            require("nvim-treesitter.configs").setup({
                endwise = {
                    enable = true,
                },
            })
        end,
    },

    {
        -- <>, "", '', etc
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",

        dependencies = {
            { "nvim-treesitter/nvim-treesitter" },
        },

        config = function()
            require("nvim-treesitter.configs").setup({
                autotag = {
                    enable = true,
                },
            })
        end,
    },
}
