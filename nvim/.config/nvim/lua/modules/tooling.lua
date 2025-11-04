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
            ensure_installed = { "lua_ls", "stylua" },
            automatic_enable = {
                exclude = { "stylua" },
            },
        },

        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
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
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                lua = { "stylua" },
            },

            default_format_opts = {
                lsp_format = "fallback",
            },

            format_on_save = { timeout_ms = 500 },
        },

        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
}
