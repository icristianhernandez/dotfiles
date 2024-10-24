return {
    -- guess-indent: Guess the indentation of a file and set the shiftwidth
    "NMAC427/guess-indent.nvim",
    lazy = false,
    config = function()
        require("guess-indent").setup()
    end,
}
