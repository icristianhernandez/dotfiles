local tools = require("extra.tools_handler")

vim.pack.add({
    "https://github.com/stevearc/conform.nvim",
})

local formatters = tools.resolve("formatters")

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require("conform").setup({
    formatters_by_ft = formatters.formatters_by_ft,
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = { timeout_ms = 500 },
})

vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({ async = true })
end, { desc = "Format buffer" })
