local lsp_servers = {
    "lua_ls",
    "taplo", -- TOML
}

local formatters = {
    lua = { "stylua" },
}

local formatters_table = {}
for _, formatters_list in pairs(formatters) do
    for _, formatter in pairs(formatters_list) do
        table.insert(formatters_table, formatter)
    end
end

return {
    "neovim/nvim-lspconfig",
    lazy = false,

    dependencies = {
        -- Telescope
        "nvim-telescope/telescope.nvim",
        {
            "williamboman/mason.nvim",
            opts = {},
        },
        {
            "williamboman/mason-lspconfig.nvim",
            opts = {
                ensure_installed = lsp_servers,
            },
        },
        {
            "nvimtools/none-ls.nvim",
            opts = {},
        },
        {
            "jay-babu/mason-null-ls.nvim",
            opts = {
                ensure_installed = formatters_table,
            },
        },
        {
            "stevearc/conform.nvim",
            keys = {
                {
                    "<leader>lf",
                    function()
                        require("conform").format({ async = true, lsp_fallback = true })
                    end,
                    mode = "",
                    desc = "Format buffer",
                },
            },
            opts = {
                formatters_by_ft = formatters,
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            },
        },
    },

    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        for _, server in ipairs(lsp_servers) do
            lspconfig[server].setup({
                capabilities = capabilities,
                -- on_attach = on_attach,
                -- on_init = on_init,
            })
        end

        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        vim.diagnostic.config({ virtual_text = false })

        vim.keymap.set("n", "<leader>lh", vim.diagnostic.open_float, { desc = "Hover information" })
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", {})
        vim.keymap.set(
            { "n", "v" },
            "<leader>la",
            vim.lsp.buf.code_action,
            { desc = "Code actions at the current position" }
        )
        vim.keymap.set(
            "n",
            "<leader>lp",
            vim.diagnostic.goto_prev,
            { desc = "Jump to the previous diagnostic in the buffer" }
        )
        vim.keymap.set(
            "n",
            "<leader>ln",
            vim.diagnostic.goto_next,
            { desc = "Jump to the next diagnostic in the buffer" }
        )
        vim.keymap.set(
            "n",
            "gD",
            vim.lsp.buf.declaration,
            { desc = "Go to the declaration of the symbol under the cursor" }
        )
        vim.keymap.set(
            "n",
            "gd",
            vim.lsp.buf.definition,
            { desc = "Go to the definition of the symbol under the cursor" }
        )
        vim.keymap.set(
            "n",
            "gi",
            vim.lsp.buf.implementation,
            { desc = "Go to the implementation(s) of the symbol under the cursor" }
        )
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename the symbol under the cursor" })
    end,
}
