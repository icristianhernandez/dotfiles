return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "echasnovski/mini.nvim",
    },
    ft = { "markdown", "Avante" },

    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        file_types = { "markdown", "Avante" },
    },
}
