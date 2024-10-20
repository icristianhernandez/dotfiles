return {
    -- nvim-treesitter: An incremental parsing system for programming tools (create a tree of the code nodes, etc)
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufRead",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-context",
            opts = {
                -- Avoid the sticky context from growing a lot.
                max_lines = 1,
                -- Match the context lines to the source code.
                multiline_threshold = 1,
                -- Disable it when the window is too small.
                min_window_height = 20,
            },
        },
    },

    config = function()
        require("nvim-treesitter.configs").setup({
            auto_install = true,
            sync_install = true,

            highlight = {
                enable = true,
                use_languagetree = true,
            },
            indent = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    -- selection with enter
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<bs>",
                },
            },

            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "fish",
                "gitcommit",
                "html",
                "javascript",
                "json",
                "json5",
                "jsonc",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "query",
                "regex",
                "rust",
                "scss",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "yaml",
                "ninja",
                "rst",
            },
        })
    end,
}
