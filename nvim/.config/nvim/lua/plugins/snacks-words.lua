vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true })

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
        vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true })
    end,
})

return {
    "folke/snacks.nvim",

    ---@module "snacks"
    ---@type snacks.Config
    opts = { words = { debounce = 100 } },
}
