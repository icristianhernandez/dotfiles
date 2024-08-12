return {
    "petertriho/nvim-scrollbar",
    event = "BufRead",
    config = function()
        require("scrollbar").setup()
    end,
}
