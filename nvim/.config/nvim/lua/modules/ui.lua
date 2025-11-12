return {
    -- nvim-lualine/lualine.nvim: statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-mini/mini.icons",
            "AndreM222/copilot-lualine",
        },
        opts = {
            options = {
                always_show_tabline = false,
            },

            sections = {
                lualine_a = {
                    {
                        "filename",
                        path = 4,
                    },
                },
                lualine_b = {
                    "diff",
                    "diagnostics",
                },
                lualine_c = {
                    {
                        -- Cached parent path getter: heavy computation is performed
                        -- in modules/extras/lualine_cache and updated via autocmds.
                        function()
                            return vim.b.lualine_cached_parent_path or ""
                        end,
                    },
                },
                lualine_x = { "copilot", "lsp_status" },
                lualine_y = { "progress" },
                lualine_z = { { "datetime", style = "%H:%M" } },
            },
            tabline = {
                lualine_b = {
                    { "tabs", mode = 2, max_length = vim.o.columns },
                },
            },
        },
        config = function(_, opts)
            local ok, cache = pcall(require, "modules.extras.lualine_cache")
            if ok and cache and type(cache.setup) == "function" then
                pcall(cache.setup)
            end

            require("lualine").setup(opts)
        end,
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
                signature = { enabled = false },
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },

            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                inc_rename = true, -- enables an input dialog for inc-rename.nvim
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
                    border = { style = "single", padding = { 0, 2 } },
                    -- filter_options = {},
                    -- win_options = { winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder" },
                },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                "smjonas/inc-rename.nvim",
                cmd = "IncRename",
                opts = {},
                init = function()
                    vim.api.nvim_create_autocmd("LspAttach", {
                        group = vim.api.nvim_create_augroup("user.lsp", {}),
                        callback = function(args)
                            local bufnr = args.buf
                            local client = vim.lsp.get_client_by_id(args.data.client_id)

                            if client and client:supports_method("textDocument/rename") then
                                vim.keymap.set("n", "grn", ":IncRename ", { buffer = bufnr, desc = "IncRename (LSP)" })
                            end
                        end,
                    })
                end,
            },
        },
    },

    {
        "nvim-mini/mini.icons",
        lazy = false,
        opts = {},

        config = function(_, opts)
            local MiniIcons = require("mini.icons")
            MiniIcons.setup(opts)
            MiniIcons.mock_nvim_web_devicons()

            -- Tweak builtin LSP kind names so completion/symbols include icons.
            MiniIcons.tweak_lsp_kind("prepend")

            -- Compact, stable diagnostic sign setup using a small mapping.
            local signs_text, signs_numhl = {}, {}
            local severities = {
                { key = "error", level = vim.diagnostic.severity.ERROR },
                { key = "warning", level = vim.diagnostic.severity.WARN },
                { key = "information", level = vim.diagnostic.severity.INFO },
                { key = "hint", level = vim.diagnostic.severity.HINT },
            }

            for _, s in ipairs(severities) do
                local icon, hl = MiniIcons.get("lsp", s.key)
                signs_text[s.level] = icon or ""
                signs_numhl[s.level] = hl
            end

            vim.diagnostic.config({ signs = { text = signs_text, numhl = signs_numhl } })

            -- Small helper for other plugin integrations to use consistently.
            _G.MiniIcons_format = function(category, name)
                local glyph, glyph_hl = MiniIcons.get(category, name)
                return { icon = glyph or "", hl = glyph_hl }
            end
        end,
    },

    {
        -- catgoose/nvim-colorizer.lua: highlight color codes inline
        -- #389812

        "catgoose/nvim-colorizer.lua",
        main = "colorizer",
        event = "BufReadPre",
        opts = {},
    },
    {
        -- OXY2DEV/helpview.nvim: improved help buffer viewer
        "OXY2DEV/helpview.nvim",
        main = "helpview",
        lazy = false,
        opts = {},
    },
    {
        -- MeanderingProgrammer/render-markdown.nvim: render markdown files with styles and icons
        "MeanderingProgrammer/render-markdown.nvim",
        main = "render-markdown",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
    {
        -- nvimdev/hlsearch.nvim: enhanced search highlighting and incremental updates
        "nvimdev/hlsearch.nvim",
        event = "BufRead",
        main = "hlsearch",
        opts = {},
    },
}
