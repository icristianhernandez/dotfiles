local tooling = require("modules.extras.tooling").tooling

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
    },
    {
        "sustech-data/wildfire.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {},
    },
    {
        "MeanderingProgrammer/treesitter-modules.nvim",
        lazy = false,
        dependencies = { "nvim-treesitter/nvim-treesitter" },

        ---@module 'treesitter-modules'
        ---@type ts.mod.UserConfig
        opts = {
            ensure_installed = {},
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            -- incremental_selection = {
            --     enable = true,
            --     keymaps = {
            --         init_selection = "<cr>",
            --         node_incremental = "<cr>",
            --         scope_incremental = false,
            --         node_decremental = "<bs>",
            --     },
            -- },
        },
    },
    {
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

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("user.lsp", {}),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then
                        return
                    end

                    if client:supports_method("textDocument/publishDiagnostics") then
                        vim.keymap.set(
                            "n",
                            "<leader>cd",
                            vim.diagnostic.open_float,
                            { buffer = args.buf, desc = "Open diagnostics" }
                        )
                    end
                end,
            })

            require("mason-lspconfig").setup(opts)
        end,
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
            "b0o/SchemaStore.nvim",
        },
    },
    {
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
        },
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "",
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
}
