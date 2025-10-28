-- UI consolidated: noice, statusline, visuals
return {

    -- folke/noice.nvim: improved UI for messages, cmdline and popupmenus
    {
        "folke/noice.nvim",
        -- smjonas/inc-rename.nvim: incremental rename UI command helper
        dependencies = { { "smjonas/inc-rename.nvim", cmd = "IncRename", opts = {} } },

        opts = {
            presets = {
                inc_rename = true,
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
            },

            lsp = { signature = { enabled = false } },

            cmdline = {
                format = {
                    filter = false,
                    lua = false,
                    help = false,
                },
            },

            views = {
                cmdline_popup = {
                    border = { style = "single", padding = { 0, 2 } },
                    -- filter_options = {},
                    -- win_options = { winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder" },
                },
            },
        },
    },
    -- nvim-lualine/lualine.nvim: statusline and tabline with customizable sections
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            tabline = {
                lualine_a = { { "filetype", icon_only = true } },
                lualine_b = {
                    { "tabs", mode = 2, max_length = vim.o.columns },
                    {
                        function()
                            vim.o.showtabline = 1
                            return ""
                        end,
                    },
                },
            },
        },
    },
    -- tadaa/vimade: subtle screen dimming visual effect
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

            local my_opts = { recipe = { "default", { animate = false } } }

            return vim.tbl_deep_extend("force", opts or {}, my_opts)
        end,
    },
    -- sphamba/smear-cursor.nvim: cursor smear animation for motion feedback
    {
        "sphamba/smear-cursor.nvim",
        cond = vim.g.neovide == nil,
        opts = { never_draw_over_target = true, hide_target_hack = true, damping = 1.0 },
    },
    -- catgoose/nvim-colorizer.lua: highlight color codes inline
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = {},
    },
    -- lukas-reineke/indent-blankline.nvim: show indent guides and scope
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
                show_start = true,
                show_end = true,
            },
        },
    },
    -- OXY2DEV/helpview.nvim: improved help buffer viewer
    {
        "OXY2DEV/helpview.nvim",
        lazy = false,
        opts = {},
    },
    -- nvimdev/hlsearch.nvim: enhanced search highlighting and incremental updates
    {
        "nvimdev/hlsearch.nvim",
        opts = {},
    },
    -- andymass/vim-matchup: enhanced % matching and surrounding-aware highlighting
    {
        "andymass/vim-matchup",
        lazy = true,
        event = { "CursorMoved", "CursorMovedI" },
        opts = function(_, opts)
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
            -- nvim-treesitter/nvim-treesitter: incremental parsing and AST-based features
            { "nvim-treesitter/nvim-treesitter", opts = { matchup = { enable = true } } },
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
}
