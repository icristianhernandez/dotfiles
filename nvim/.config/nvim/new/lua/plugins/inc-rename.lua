return {
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.keymap.set("n", "<leader>cr", function()
                local inc_rename = require("inc_rename")
                return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
            end, { expr = true, desc = "Rename (inc-rename.nvim)" })
        end,
    },
    {
        "folke/noice.nvim",
        optional = true,
        opts = {
            presets = { inc_rename = true },
        },
    },
}
