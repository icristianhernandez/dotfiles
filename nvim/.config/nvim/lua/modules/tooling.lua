local lsps_to_use_and_install = { "lua_ls", "vtsls", "eslint" }
local lsps_to_just_use = {}
local formatters_linters_to_install = { "stylua", "prettierd" }
local formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    json = { "prettierd" },
    css = { "prettierd" },
    html = { "prettierd" },
    markdown = { "prettierd" },
    yaml = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescriptreact = { "prettierd" },
    scss = { "prettierd" },
    less = { "prettierd" },
    jsonc = { "prettierd" },
    vue = { "prettierd" },
    svelte = { "prettierd" },
    graphql = { "prettierd" },
}
local extra_nonels_initialization = {
    { method = "diagnostics", name = "fish" },
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
    },
    {
        "MeanderingProgrammer/treesitter-modules.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ---@module 'treesitter-modules'
        ---@type ts.mod.UserConfig
        opts = {
            ensure_installed = {},
            auto_install = true,

            highlight = {
                enable = true,
            },

            indent = {
                enable = true,
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<cr>",
                    node_incremental = "<cr>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
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
        opts = {
            ensure_installed = lsps_to_use_and_install,
            automatic_enable = vim.tbl_deep_extend("force", lsps_to_use_and_install, lsps_to_just_use),
        },

        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
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
            ensure_installed = formatters_linters_to_install,
            methods = {
                formatting = false,
            },
        },
    },
    -- {
    --     "WhoIsSethDaniel/mason-tool-installer.nvim",
    --     dependencies = {
    --         "mason-org/mason-lspconfig.nvim",
    --     },
    --     opts = {
    --         ensure_installed = {
    --             "stylua",
    --             "prettierd",
    --         },
    --     },
    -- },
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
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            -- Define your formatters
            formatters_by_ft = formatters_by_ft,

            default_format_opts = {
                lsp_format = "fallback",
            },

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
            for _, item in ipairs(extra_nonels_initialization) do
                table.insert(sources, null_ls.builtins[item.method][item.name])
            end

            null_ls.setup({
                sources = sources,
            })
        end,
    },
}
