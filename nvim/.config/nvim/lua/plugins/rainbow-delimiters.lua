return {
    -- rainbow-delimiters: highlight the {} based on depth level
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = true,
    event = "BufReadPre",
}
