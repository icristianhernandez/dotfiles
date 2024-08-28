return {
    "stevearc/dressing.nvim",
    -- event = "UIEnter",
    lazy = false,
    config = function()
        require("dressing").setup()
    end,
}
