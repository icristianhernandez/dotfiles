-- UI components and visual enhancements
return {
    -- nvim-lualine/lualine.nvim: Statusline configuration
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            tabline = {
                -- lualine_a = {
                --     { "filetype", icon_only = true },
                -- },
                -- lualine_b = {
                --     { "tabs", mode = 2, max_length = vim.o.columns },
                --     {
                --         function()
                --             vim.o.showtabline = 1
                --             return ""
                --         end,
                --     },
                -- },
            },
        },
    },

    -- folke/noice.nvim: Enhanced UI for messages, cmdline and popups
    {
        "folke/noice.nvim",
        opts = {
            lsp = {
                signature = {
                    enabled = false,
                },
            },

            cmdline = {
                format = {
                    filter = false,
                    lua = false,
                    help = false,
                },
            },

            views = {
                cmdline_popup = {
                    border = {
                        style = "single",
                        padding = { 0, 2 },
                    },
                    filter_options = {},
                    win_options = {
                        winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    },
                },
            },
        },
    },

    -- lukas-reineke/indent-blankline.nvim: Indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",

        opts = {
            indent = {
                char = "▏",
                tab_char = "▏",
                smart_indent_cap = true,
                repeat_linebreak = true,
            },
            scope = {
                enabled = true,
            },
        },
    },

    -- tadaa/vimade: Dim inactive windows
    {
        "tadaa/vimade",
        lazy = true,
        event = "VeryLazy",

        opts = function(_, opts)
            Snacks.toggle({
                name = "Vimade",
                get = function()
                    return true
                end,
                set = function()
                    vim.cmd("VimadeToggle")
                end,
            }):map("<leader>uv")

            local my_opts = {
                recipe = { "default", { animate = false } },
            }

            return vim.tbl_extend("force", opts or {}, my_opts)
        end,
    },

    -- sphamba/smear-cursor.nvim: Animated cursor movement
    {
        "sphamba/smear-cursor.nvim",

        opts = {
            never_draw_over_target = true,
            -- damping = 1.0,
        },
    },

    -- OXY2DEV/helpview.nvim: Enhanced help buffer styling
    {
        "OXY2DEV/helpview.nvim",
        lazy = false,
        opts = {},
    },

    -- HiPhish/rainbow-delimiters.nvim: Colorful bracket highlighting by depth
    {
        "HiPhish/rainbow-delimiters.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        lazy = true,
        event = "BufReadPre",
    },

    -- andymass/vim-matchup: Enhanced matching of parentheses and keywords
    {
        "andymass/vim-matchup",
        lazy = true,
        event = { "CursorMoved", "CursorMovedI" },

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
    },
}
