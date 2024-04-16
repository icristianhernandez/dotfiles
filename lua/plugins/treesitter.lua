return {
    "nvim-treesitter/nvim-treesitter",
    -- need to configure
    dependencies = {
        {
            "andersevenrud/nvim_context_vt",
            opts = {},
        }
        -- "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    event = "BufRead",

    config = function()
        require("nvim-treesitter.configs").setup({
            auto_install = true,

            highlight = {
                enable = true
            },
            indent = {
                enable = true
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Leader>ss",
                    node_incremental = "<Leader>si",
                    scope_incremental = "<Leader>sc",
                    node_decremental = "<Leader>sd",
                },
            },

            ensure_installed = {
                "lua",
                "python",
                "vim",
                "vimdoc",
                "c",
                "cpp",
                "cmake",
                "rust",
                "go",
                "query",
                "elixir",
                "heex",
                "javascript",
                "html",
            },
        })
    end,
}
