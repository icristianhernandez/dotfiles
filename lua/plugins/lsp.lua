-- Need review:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
-- Try to dinamycally load the formatters, linters, etc of null_ls
-- Also try to do an ensure installation of these servers

local lsp_servers = {
	"lua_ls",
	"pyright",
	-- taplo: lsp for TOML
	"taplo",
}

local formatters = {
	python = { "black" },
	lua = { "stylua" },
}

local formatters_table = {}
for _, formatter in ipairs(formatters) do
	table.insert(formatters_table, unpack(formatter))
end

return {
	-- for installing lsp
	{
		"neovim/nvim-lspconfig",
		dependencies = {
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
				"jay-babu/mason-null-ls.nvim",
				opts = {
					ensure_installed = formatters_table,
				},
			},
		},

		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- local on_attach = function(client, bufnr)
			-- 	require("mason-lspconfig").on_attach(client, bufnr)
			-- end
			-- local on_init = function(client)
			-- 	require("mason-lspconfig").on_init(client)
			-- end

			for _, server in ipairs(lsp_servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
					-- on_attach = on_attach,
					-- on_init = on_init,
				})
			end

			lspconfig["pyright"].setup({
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			-- vim.diagnostic.config({
			-- 	virtual_text = false,
			-- })

			vim.keymap.set("n", "<leader>lh", vim.diagnostic.open_float, { desc = "Hover information" })
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
				"<leader>ld",
				vim.lsp.buf.declaration,
				{ desc = "Go to the declaration of the symbol under the cursor" }
			)
			vim.keymap.set(
				"n",
				"<leader>lD",
				vim.lsp.buf.definition,
				{ desc = "Go to the definition of the symbol under the cursor" }
			)
			vim.keymap.set(
				"n",
				"<leader>li",
				vim.lsp.buf.implementation,
				{ desc = "Go to the implementation(s) of the symbol under the cursor" }
			)
			vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename the symbol under the cursor" })
			vim.keymap.set(
				"n",
				"<leader>lR",
				vim.lsp.buf.references,
				{ desc = "Show references to the symbol under the cursor" }
			)

			-- custom characters for the signs of visual columns
			local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
		end,
	},

	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					-- null_ls.builtins.formatting.stylua,
					-- null_ls.builtins.formatting.black,
					-- null_ls.builtins.diagnostics.eslint,
					-- null_ls.builtins.completion.spell,
				},
			})

			-- vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Autoformat" })
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = formatters,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
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
	},
}
