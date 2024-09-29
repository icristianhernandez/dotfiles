return {
    "mvllow/modes.nvim",
    event = "BufReadPre",
    config = function()
        require("modes").setup({
            line_opacity = 0.3,
            set_number = true,
        })
    end,
}
