return {
    {
        -- for dark mode
        "rmehri01/onenord.nvim",
    },
    {
        -- for light mode
        "folke/tokyonight.nvim",
    },
    {
        -- sneak of the line when doing :50g, for example
        "nacro90/numb.nvim",
        event = "BufRead",
        opts = {},
    },
    {
        -- for changing some uis
        "stevearc/dressing.nvim",
        event = "UIEnter",
        opts = {},
    },

    {
        "dstein64/nvim-scrollview",
        opts = {},
    },

    {
        "shortcuts/no-neck-pain.nvim",
        opts = {
            width = 90,

            autocmds = {
                enableOnVimEnter = true,
                reloadOnColorSchemeChange = true,
            },

            mappings = {
                enable = true,
                toggle = "<leader>z",
            },
        },
    },

    {
        "folke/which-key.nvim",
        event = "VimEnter",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {},
    },

    {
        "f-person/auto-dark-mode.nvim",
        config = {
            update_interval = 1000,
            set_dark_mode = function()
                vim.cmd("colorscheme onenord")
            end,
            set_light_mode = function()
                vim.cmd("colorscheme tokyonight-day")
            end,
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)

            vim.g.rainbow_delimiters = { highlight = highlight }
            require("ibl").setup({ scope = { highlight = highlight } })

            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end,
    },

    {
        "NvChad/nvim-colorizer.lua",
        event = "User FilePost",
        opts = { user_default_options = { names = false } },
        config = function(_, opts)
            require("colorizer").setup(opts)

            -- execute colorizer as soon as possible
            vim.defer_fn(function()
                require("colorizer").attach_to_buffer(0)
            end, 0)
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },

        opts = {
            options = { theme = "auto" },
        },
    },

    {
        -- fade inactive windows
        "TaDaa/vimade",
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",

        opts = {
            routes = {
                {
                    filter = { event = "notify", find = "No information available" },
                    opts = { skip = true },
                },
            },

            views = {
                cmdline_popup = {
                    position = {
                        row = 5,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                    -- border = {
                    --     style = "none",
                    --     padding = { 2, 3 },
                    -- },
                    -- filter_options = {},
                    -- win_options = {
                    --     winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
                    -- },
                },
            },

            presets = {
                lsp_doc_border = true,
            },

            cmdline = {
                format = {
                    conceal = false,
                },
            },

            messages = {
                enabled = false,
            },
        },

        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },

    {
        "nvimdev/hlsearch.nvim",
        event = "BufRead",
        opts = {},
    },

    {
        "hiphish/rainbow-delimiters.nvim",
        event = "BufRead",
        config = function()
            local rainbow_delimiters = require("rainbow-delimiters")

            vim.g.rainbow_delimiters = {
                strategy = {
                    [""] = rainbow_delimiters.strategy["global"],
                    vim = rainbow_delimiters.strategy["local"],
                },
                query = {
                    [""] = "rainbow-delimiters",
                    lua = "rainbow-blocks",
                },
                priority = {
                    [""] = 110,
                    lua = 210,
                },
                highlight = {
                    "RainbowDelimiterRed",
                    "RainbowDelimiterYellow",
                    "RainbowDelimiterBlue",
                    "RainbowDelimiterOrange",
                    "RainbowDelimiterGreen",
                    "RainbowDelimiterViolet",
                    "RainbowDelimiterCyan",
                },
            }
        end,
    },

    {
        "utilyre/sentiment.nvim",
        version = "*",
        event = "VeryLazy", -- keep for lazy loading
        opts = {
            -- config
        },
        init = function()
            -- `matchparen.vim` needs to be disabled manually in case of lazy loading
            vim.g.loaded_matchparen = 1
        end,
    },

}
