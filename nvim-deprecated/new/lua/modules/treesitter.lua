return {
    -- nvim-treesitter/nvim-treesitter: incremental parsing, highlighting and AST-powered features
    "nvim-treesitter/nvim-treesitter",
    branch = "master",

    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },

    dependencies = {
        -- nvim-treesitter/nvim-treesitter-context: show current context (function/class) at top
        {
            "nvim-treesitter/nvim-treesitter-context",
            opts = {
                max_lines = 1,
                multiline_threshold = 1,
                min_window_height = 20,
            },
        },
    },

    opts = function(_, opts)
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

        local new_opts = {
            auto_install = true,
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "css",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "rust",
                "typescript",
                "yaml",
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<bs>",
                },
            },

            highlight = { enable = true },
            indent = { enable = true },
        }

        return vim.tbl_deep_extend("force", opts or {}, new_opts)
    end,

    keys = {
        { "<CR>", desc = "Increment Selection", mode = { "x", "n" } },
        { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
}
