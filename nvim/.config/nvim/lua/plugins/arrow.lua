return {
    "otavioschwanck/arrow.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        -- or if using `mini.icons`
        -- { "echasnovski/mini.icons" },
    },

    keys = { "ñ" },

    opts = {
        leader_key = "ñ", -- Recommended to be a single key
        buffer_leader_key = "m", -- Per Buffer Mappings
    },
}
