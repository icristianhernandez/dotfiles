return {
    "nvim-lualine/lualine.nvim",
    opts = {
        tabline = {
            lualine_a = {
                { "filetype", icon_only = true },
            },
            lualine_b = {
                { "tabs", mode = 2, max_length = vim.o.columns },
                {
                    function()
                        vim.o.showtabline = 1
                        return ""
                    end,
                },
            },
        },
    },
}
