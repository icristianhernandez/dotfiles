return {
    -- Surround text objects with pairs of characters (also, visual selections)
    "kylechui/nvim-surround",
    event = "VeryLazy",

    config = function()
        require("nvim-surround").setup({
            keymaps = {
                visual = "ñ",
            },
        })
    end,
}
