return {
	{
		"hrsh7th/nvim-cmp",

		event = "InsertEnter",

		dependencies = {
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			-- "hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",

			{
				-- it's not being used actually
				"L3MON4D3/LuaSnip",

				dependencies = {
					"saadparwaiz1/cmp_luasnip",
					"rafamadriz/friendly-snippets",
				},

				opts = {},
			},
		},

		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},

				window = {
					completion = {
						border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
						winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
					},

					documentation = {
						border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
						winhighlight = "Normal:CmpPmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					},
				},

				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),

					-- Navigate options with tab and shift-tab
					-- when only one option and press tab, auto confirm
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if #cmp.get_entries() == 1 then
								cmp.confirm({ select = true })
							else
								cmp.select_next_item()
							end
						elseif has_words_before() then
							cmp.complete()
							if #cmp.get_entries() == 1 then
								cmp.confirm({ select = true })
							end
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping.select_prev_item(),

					-- Confirm completion with enter
					-- safetly confirm, only confirm if a option it's
					-- explicitly selected
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
						s = cmp.mapping.confirm({ select = true }),
						c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					}),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "buffer", keyword_length = 3 },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),

				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[Latex]",
						},
					}),
				},
			})
		end,
	},
}
