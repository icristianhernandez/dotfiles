return {
    "mvllow/modes.nvim",
    event = { "ModeChanged", "BufWinEnter", "WinEnter" },
    config = function()
        require("modes").setup({
            line_opacity = 0.3,
            set_number = true,
        })
    end,
}
