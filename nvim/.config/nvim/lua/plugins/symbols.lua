return {
    "oskarrrrrrr/symbols.nvim",

    keys = { { "<leader>us", "<cmd>Symbols<cr>" } },

    config = function()
        local r = require("symbols.recipes")

        require("symbols").setup(r.DefaultFilters, r.AsciiSymbols, {
            hide_cursor = false,
            sidebar = {
                open_direction = "left",
                close_on_goto = true,

                preview = {
                    show_always = true,
                },

                keymaps = {
                    ["o"] = "goto-symbol",
                    ["<CR>"] = "peek-symbol",
                },
            },
        })
    end,
}

-- return {
--     "stevearc/aerial.nvim",
--     lazy = false,
--     opts = {
--         filter_kind = true,
--     },
--
--     keys = {
--         { "<leader>us", "<cmd>NoNeckPain<cr><cmd>AerialToggle<cr>", desc = "Toggle Noneckpain and Aerial" },
--     },
--
--     dependencies = {
--         "nvim-treesitter/nvim-treesitter",
--         "nvim-tree/nvim-web-devicons",
--     },
-- }

-- return {
--     "hedyhli/outline.nvim",
--     keys = { { "<leader>us", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
--     config = function()
--         require("outline").setup({
--             outline_window = {
--                 position = "left",
--                 split_command = "vsplit",
--                 auto_close = true,
--             },
--         })
--     end,
-- }
