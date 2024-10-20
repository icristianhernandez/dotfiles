return {
    -- dressing: change vim.ui.select and vim.ui.input hooks
    "stevearc/dressing.nvim",
    event = "UIEnter",
    -- lazy = false,
    config = function()
        require("dressing").setup()
    end,
}
