local tooling = require("modules.extras.tooling")

local lsp_servers = tooling.mason.auto_install.lsp
local tools = tooling.mason.auto_install.tools

return {
    -- Clangd extensions for enhanced C/C++ LSP features
    { "p00f/clangd_extensions.nvim" },
    -- JSON schema store for LSPs
    { "b0o/schemastore.nvim" },
    -- folke/lazydev.nvim: Faster LuaLS setup for Neovim
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                { path = "snacks.nvim", words = { "Snacks" } },
            },
        },
    },
    -- LSP server installation and diagnostics config
    {
        "neovim/nvim-lspconfig",
        opts = {
            diagnostics = {
                severity_sort = true,
                virtual_text = false,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.HINT] = "",
                    },
                    numhl = {
                        [vim.diagnostic.severity.WARN] = "WarningMsg",
                        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
                        [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
                        [vim.diagnostic.severity.HINT] = "DiagnosticHint",
                    },
                },
            },
        },
        config = function(_, opts)
            vim.diagnostic.config(opts.diagnostics)
        end,
    },

    -- mason-lspconfig to auto-install servers
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            { "mason-org/mason.nvim", opts = {} },
        },
        opts = {
            automatic_enable = true,
            ensure_installed = lsp_servers,
        },
    },

    -- External tools: formatters, linters, debuggers, etc.
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = tools,
            run_on_start = true,
            start_delay = 3000,
        },
    },

    -- Formatting via conform.nvim
    {
        "stevearc/conform.nvim",
        dependencies = { "mason-org/mason.nvim" },
        cmd = "ConformInfo",
        opts = {
            formatters_by_ft = tooling.formatters.by_ft,

            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return {}
            end,

            default_format_opts = {
                timeout_ms = 3000,
                async = false,
                quiet = false,
                lsp_format = "fallback",
            },

            formatters = tooling.formatters.config,
        },

        config = function(_, opts)
            local conform = require("conform")
            conform.setup(opts)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function(args)
                    local ft = vim.bo[args.buf].filetype
                    if conform.has_formatter(ft) then
                        vim.bo[args.buf].formatexpr = "v:lua.require'conform'.formatexpr()"
                    end
                end,
            })
        end,

        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format()
                end,
                desc = "Format File with Conform",
            },
            {
                "<leader>cF",
                function()
                    if vim.b.conform_autoformat_enabled == nil or vim.b.conform_autoformat_enabled then
                        vim.b.conform_autoformat_enabled = false
                        print("Conform autoformat disabled for this buffer")
                    else
                        vim.b.conform_autoformat_enabled = true
                        print("Conform autoformat enabled for this buffer")
                    end
                end,
                desc = "Toggle Conform Autoformat for Buffer",
            },
        },
    },

    -- Linting via nvim-lint
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost", "InsertLeave" },
        opts = {
            linters_by_ft = tooling.linters.by_ft,
            debounce_ms = 300,
        },

        config = function(_, opts)
            local lint = require("lint")

            lint.linters_by_ft = opts.linters_by_ft or {}

            -- Apply centralized per-linter configs/conditions
            for linter_name, linter_config in pairs((tooling.linters and tooling.linters.config) or {}) do
                if lint.linters[linter_name] and type(linter_config) == "table" then
                    for option_key, option_value in pairs(linter_config) do
                        lint.linters[linter_name][option_key] = option_value
                    end
                end
            end

            -- debounce helper
            local function debounce(ms, fn)
                local unpack = table.unpack or unpack
                return function(...)
                    local argv = { ... }
                    local timer = vim.uv.new_timer()
                    timer:start(ms, 0, function()
                        timer:stop()
                        timer:close()
                        if fn then
                            vim.schedule_wrap(fn)(unpack(argv))
                        end
                    end)
                end
            end

            local run_lint = debounce(opts.debounce_ms or 300, function()
                lint.try_lint()
            end)

            local group = vim.api.nvim_create_augroup("nvim-lint-basic", { clear = true })
            vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
                group = group,
                callback = function()
                    run_lint()
                end,
            })
        end,
        keys = {
            {
                "<leader>cl",
                function()
                    require("lint").try_lint()
                end,
                desc = "Lint file",
            },
        },
    },
}
