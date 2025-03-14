return {
    "folke/snacks.nvim",

    opts = {
        styles = {
            scratch = {
                height = function()
                    return vim.o.lines - 3
                end,

                -- height = (function()
                --     local display_height = vim.o.lines
                --     if display_height > 35 then
                --         return 30
                --     else
                --         return display_height - 5
                --     end
                -- end)(),
            },
        },
    },

    keys = {
        {
            "<C-n>",
            function()
                Snacks.scratch()
            end,
            desc = "Toggle Scratch Buffer",
        },
    },
}
