return {
    "petertriho/nvim-scrollbar",
    event = "BufRead",
    config = function()
        require("scrollbar").setup({
            handle = {
                blend = 5,
            },
        })
    end,
}
