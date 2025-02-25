return {
    "folke/snacks.nvim",

    opts = {
        styles = {
            scratch = {
                -- height = 25,

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

    -- keys = {
    --     {
    --         "<c-space>",
    --         function()
    --             Snacks.terminal()
    --         end,
    --         desc = "Terminal (cwd)",
    --         mode = { "n", "t" },
    --     },
    -- },
}
