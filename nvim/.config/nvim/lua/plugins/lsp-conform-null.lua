-- all lsp setups including formatters and null-ls setups
-- with conform for autosave formatting in filetypes
-- with autoinstall of lsp servers and formatters
-- and auto assignation of lsp servers

local lsp_servers = {
    -- "typos_lsp", -- code-spell checker
    "lua_ls",
    -- for TOML:
    "taplo",
    -- for Python:
    "pyright",
    -- for C/C++:
    "clangd",
    -- for Markdown:
    "marksman",
}

local formatters = {
    lua = { "stylua" },
    python = { "black" },
    markdown = { "prettier" },
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
        { "nvim-telescope/telescope.nvim" },
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
            event = { "BufWritePre" },
            cmd = { "ConformInfo" },
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

            init = function()
                vim.o.formatexpr = [[v:lua.require("conform").formatexpr()]]
            end,

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
        local capabilities
        if vim.fn.exists(":CmpNvimLsp") == 2 then
            capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
        else
            capabilities = vim.lsp.protocol.make_client_capabilities()
            -- report that cmp is not installed
            print("cmp_nvim_lsp is not installed")
        end
        local on_attach_keymaps = function(_, bufnr)
            local nmap = function(keys, func, desc)
                if desc then
                    desc = "LSP: " .. desc
                end

                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
            end
            vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
            vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = 0 })
            nmap("K", vim.lsp.buf.hover, "Hover Documentation")

            nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
            nmap("gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", "Open Definition in Vertical Split")
            nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            -- nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
            nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
            nmap("<leader>li", vim.lsp.buf.incoming_calls, "[I]ncoming [C]alls")
            nmap("<leader>la", vim.lsp.buf.code_action, "[C]ode [A]ction")
            nmap("<leader>lo", vim.lsp.buf.outgoing_calls, "[O]utgoing [C]alls")
            nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
            nmap("<leader>lr", vim.lsp.buf.rename, "Rename Symbol")

            -- nmap("<leader>fs", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
            -- nmap("<leader>fS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

            -- Lesser used LSP functionality
            -- nmap("<leader>wA", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
            -- nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
            -- nmap("<leader>wl", function()
            --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            -- end, "[W]orkspace [L]ist Folders")
            --
            -- nmap("<c-f>", vim.lsp.buf.format, "Format Buffer")
            --
            -- nmap("<leader>br", require("dap").toggle_breakpoint, "Toggle Breakpoint")
        end

        for _, server in ipairs(lsp_servers) do
            lspconfig[server].setup({
                capabilities = capabilities,
                on_attach = on_attach_keymaps,
                -- on_init = on_init,
            })
        end

        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        vim.diagnostic.config({ virtual_text = false })
    end,
}
