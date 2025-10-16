return {
    -- Impose restrictions on key usage to encourage better habits
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
        restricted_keys = {
            ["k"] = false,
            ["j"] = false,
            ["<Up>"] = false,
            ["<Down>"] = false,
            ["<Left>"] = false,
            ["<Right>"] = false,
        },
    },
}
