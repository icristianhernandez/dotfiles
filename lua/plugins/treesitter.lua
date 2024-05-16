return {
    "nvim-treesitter/nvim-treesitter",
    -- need to configure
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
                    -- selection with enter
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<bs>",
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
