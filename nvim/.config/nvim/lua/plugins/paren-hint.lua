return {
    "code-biscuits/nvim-biscuits",
    -- event = "BufRead",
    lazy = false,
    config = function()
        require("nvim-biscuits").setup({
            cursor_line_only = true,
            default_config = {
                prefix_string = " ✨   ",
                min_distance = 3,
            },
        })
    end,
}
