return {
    "nvim-lualine/lualine.nvim",
    opts = {
        tabline = {
            -- lualine_a = {
            --     { "filetype", icon_only = true },
            -- },
            lualine_a = {
                { "tabs", mode = 2, max_length = vim.o.columns },
                {
                    function()
                        --HACK: lualine will set &showtabline to 2 if you have configured
                        --lualine for displaying tabline. We want to restore the default
                        --behavior here.
                        vim.o.showtabline = 1
                        return ""
                    end,
                },
            },
        },
    },
}
