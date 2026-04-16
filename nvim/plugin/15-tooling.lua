vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/b0o/SchemaStore.nvim",
    "https://github.com/p00f/clangd_extensions.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/nvimtools/none-ls.nvim",
    "https://github.com/jay-babu/mason-null-ls.nvim",
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/stevearc/conform.nvim",
})

local tooling = require("modules.extras.tooling").tooling

-- mason.nvim
require("mason").setup({})

-- mason-lspconfig.nvim
local lsp_configs = require("modules.extras.tooling").tooling.mason_lspconfig.configs or {}
local to_enable = tooling.mason_lspconfig.automatic_enable

for server, cfg in pairs(lsp_configs) do
    if type(cfg) == "function" then
        cfg = cfg()
    end
    vim.lsp.config[server] = cfg
end

for _, server in ipairs(to_enable) do
    vim.lsp.enable(server)
end

require("mason-lspconfig").setup({
    ensure_installed = tooling.mason_lspconfig.ensure_installed,
})

-- mason-null-ls.nvim
require("mason-null-ls").setup({
    ensure_installed = tooling.mason_null_ls.ensure_installed,
    methods = {
        formatting = false,
    },
    handlers = {},
})

-- none-ls.nvim
local null_ls = require("null-ls")
local sources = {}
for _, item in ipairs(tooling.null_ls.init) do
    table.insert(sources, null_ls.builtins[item.method][item.name])
end
null_ls.setup({ sources = sources })

-- lazydev.nvim
require("lazydev").setup({
    library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
    },
})

-- conform.nvim
require("conform").setup({
    formatters_by_ft = tooling.conform.formatters_by_ft,
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = { timeout_ms = 500 },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({ async = true })
end, { desc = "Format buffer" })
