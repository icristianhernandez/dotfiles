local tools = require("extra.tools_handler")

vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/b0o/SchemaStore.nvim",
    "https://github.com/p00f/clangd_extensions.nvim",
})

local lsp = tools.resolve("lsp")

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = lsp.ensure_installed,
})

require("lazydev").setup({
    library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
    },
})

for server, config in pairs(lsp.settings) do
    vim.lsp.config[server] = config
end

for _, server in ipairs(lsp.enable) do
    vim.lsp.enable(server)
end
