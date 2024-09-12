return {
    {
        "alvarosevilla95/luatab.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VimEnter",
        config = function()
            require("luatab").setup()
        end,
    },
}
