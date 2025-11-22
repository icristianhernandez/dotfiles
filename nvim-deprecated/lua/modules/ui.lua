-- UI consolidated: noice, statusline, visuals
return {
    -- nvim-mini/mini.icons: customizable filetype and filename icons
    {
        "nvim-mini/mini.icons",
        main = "mini.icons",
        opts = {
            file = {
                [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
                ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
            },
            filetype = {
                dotenv = { glyph = "", hl = "MiniIconsYellow" },
            },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },

    -- folke/noice.nvim: improved UI for messages, cmdline and popupmenus
    {
        "folke/noice.nvim",
        -- smjonas/inc-rename.nvim: incremental rename UI command helper
        dependencies = { { "smjonas/inc-rename.nvim", cmd = "IncRename", opts = {} } },

        keys = {
            { "<leader>sn", "", desc = "+noice" },
            {
                "<leader>snl",
                function()
                    require("noice").cmd("last")
                end,
                desc = "Noice Last Message",
            },
            {
                "<leader>snh",
                function()
                    require("noice").cmd("history")
                end,
                desc = "Noice History",
            },
            {
                "<leader>sna",
                function()
                    require("noice").cmd("all")
                end,
                desc = "Noice All",
            },
            {
                "<leader>snd",
                function()
                    require("noice").cmd("dismiss")
                end,
                desc = "Dismiss All",
            },
            {
                "<c-f>",
                function()
                    if not require("noice.lsp").scroll(4) then
                        return "<c-f>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll Forward",
                mode = { "i", "n", "s" },
            },
            {
                "<c-b>",
                function()
                    if not require("noice.lsp").scroll(-4) then
                        return "<c-b>"
                    end
                end,
                silent = true,
                expr = true,
                desc = "Scroll Backward",
                mode = { "i", "n", "s" },
            },
        },

        ---@module 'noice'
        ---@type noice.Config
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
            options = { theme = "auto" },
            -- tabline = {
            --     lualine_a = { { "filetype", icon_only = true } },
            --     lualine_b = {
            --         { "tabs", mode = 2, max_length = vim.o.columns },
            --         {
            --             function()
            --                 vim.o.showtabline = 1
            --                 return ""
            --             end,
            --         },
            --     },
            -- },
        },
        config = function(_, opts)
            require("lualine").setup(opts)
        end,
    },
    -- tadaa/vimade: subtle screen dimming visual effect
    {
        "tadaa/vimade",
        lazy = true,
        event = "VeryLazy",
        config = function()
            Snacks.toggle({
                name = "Vimade",
                get = function()
                    return true
                end,
                set = function()
                    vim.cmd("VimadeToggle")
                end,
            }):map("<leader>uv")

            vim.g.vimade = { recipe = { "default", { animate = false } } }
        end,
    },
    -- sphamba/smear-cursor.nvim: cursor smear animation for motion feedback
    {
        "sphamba/smear-cursor.nvim",
        cond = vim.g.neovide == nil,
        opts = { never_draw_over_target = true, hide_target_hack = true, damping = 1.0 },
        config = function(_, opts)
            require("smear_cursor").setup(opts)
        end,
    },
    -- catgoose/nvim-colorizer.lua: highlight color codes inline
    {
        "catgoose/nvim-colorizer.lua",
        main = "colorizer",
        event = "BufReadPre",
        opts = {},
    },
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
    -- OXY2DEV/helpview.nvim: improved help buffer viewer
    {
        "OXY2DEV/helpview.nvim",
        main = "helpview",
        lazy = false,
        opts = {},
    },
    -- MeanderingProgrammer/render-markdown.nvim: render markdown files with styles and icons
    {
        "MeanderingProgrammer/render-markdown.nvim",
        main = "render-markdown",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
    -- nvimdev/hlsearch.nvim: enhanced search highlighting and incremental updates
    {
        "nvimdev/hlsearch.nvim",
        main = "hlsearch",
        opts = {},
    },
    -- andymass/vim-matchup: enhanced % matching and surrounding-aware highlighting
    {
        "andymass/vim-matchup",
        lazy = true,
        event = { "CursorMoved", "CursorMovedI" },
        config = function()
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
