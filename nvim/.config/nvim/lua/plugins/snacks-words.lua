vim.api.nvim_create_autocmd({ "LspAttach" }, {
    pattern = { "*" },
    callback = function()
        vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
        vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true })
    end,
})

return {
    "folke/snacks.nvim",

    opts = { words = { debounce = 100 } },
}
