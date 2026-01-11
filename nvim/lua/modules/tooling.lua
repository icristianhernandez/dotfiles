local tooling = require("modules.extras.tooling").tooling

return {
    {
        -- nvim-treesitter/nvim-treesitter: incremental parsing & AST features
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        dependencies = {
            {
                -- nvim-treesitter/nvim-treesitter-context: show current context (function/class) at top
                "nvim-treesitter/nvim-treesitter-context",
                main = "treesitter-context",
                opts = {
                    max_lines = 1,
                    multiline_threshold = 1,
                    min_window_height = 20,
                },
            },
        },
    },
    {
        -- sustech-data/wildfire.nvim: treesitter-based incremental selection
        "sustech-data/wildfire.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            surrounds = {},
        },
    },
    {
        -- TS config and modules loader
        "MeanderingProgrammer/treesitter-modules.nvim",
        lazy = false,
        dependencies = { "nvim-treesitter/nvim-treesitter" },

        opts = function()
            ---@module 'treesitter-modules'
            ---@type ts.mod.UserConfig
            return {
                ensure_installed = tooling.treesitter.ensure_installed,
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },

                -- incremental_selection = {
                --     enable = true,
                --     keymaps = {
                --         init_selection = "<CR>",
                --         node_incremental = "<CR>",
                --         node_decremental = "<bs>",
                --     },
                -- },
            }
        end,
    },

    {
        -- mason-org/mason-lspconfig.nvim: bridge between mason.nvim and nvim-lspconfig
        "mason-org/mason-lspconfig.nvim",
        opts = function()
            return {
                ensure_installed = tooling.mason_lspconfig.ensure_installed,
            }
        end,
        config = function(_, opts)
            local configs = require("modules.extras.tooling").tooling.mason_lspconfig.configs or {}
            local to_enable = tooling.mason_lspconfig.automatic_enable

            for server, cfg in pairs(configs) do
                if type(cfg) == "function" then
                    cfg = cfg()
                end
                vim.lsp.config[server] = cfg
            end

            for _, server in ipairs(to_enable) do
                vim.lsp.enable(server)
            end

            require("mason-lspconfig").setup(opts)
        end,
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
            "b0o/SchemaStore.nvim",
            "p00f/clangd_extensions.nvim",
        },
    },
    {
        -- jay-babu/mason-null-ls.nvim: bridge between mason.nvim and null-ls.nvim
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        opts = {
            ensure_installed = tooling.mason_null_ls.ensure_installed,
            methods = {
                formatting = false,
            },
            handlers = {},
        },
    },
    {
        -- setup lua_ls to fully and lazyly support neovim
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "snacks.nvim", words = { "Snacks" } },
            },
        },
    },
    {
        -- stevearc/conform.nvim: universal formatter plugin
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "n",
                desc = "Format buffer",
            },
        },

        ---@module 'conform'
        ---@type conform.setupOpts
        opts = {
            formatters_by_ft = tooling.conform.formatters_by_ft,
            default_format_opts = { lsp_format = "fallback" },
            format_on_save = { timeout_ms = 500 },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
    {
        -- nvimtools/none-ls.nvim: use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            local sources = {}
            for _, item in ipairs(tooling.null_ls.init) do
                table.insert(sources, null_ls.builtins[item.method][item.name])
            end
            null_ls.setup({ sources = sources })
        end,
    },

    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod", lazy = true },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.dbs = {
                {
                    name = "supabase-local",
                    url = "postgresql://postgres:postgres@127.0.0.1:54322/postgres?sslmode=disable",
                },
            }
        end,
        keys = {
            {
                -- that's need to be added to whichkey as groupspace
                "<leader>du",
                "<cmd>DBUIToggle<cr>",
                desc = "Toggle Database UI",
            },
        },
    },
}
