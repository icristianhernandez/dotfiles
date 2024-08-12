return {
    "stevearc/dressing.nvim",
    event = "UIEnter",
    config = function()
        require("dressing").setup()
    end
}
