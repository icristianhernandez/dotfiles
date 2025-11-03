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
        lazy = false,
        ---@type snacks.Config
        opts = {
            scroll = { enabled = true },
            notifier = { enabled = true },
        },

        config = function(_, opts)
            local Snacks = require("snacks")
            Snacks.setup(opts)

            vim.notify = Snacks.notifier
        end,
    },
    -- lazy.nvim
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            -- {
            --     "rcarriga/nvim-notify",
            --     opts = function(_, previous_opts)
            --         vim.notify = require("notify")
            --
            --         return previous_opts
            --     end,
            -- },
        },
    },
}
