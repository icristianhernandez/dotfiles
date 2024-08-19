return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/lspkind-nvim",

        -- snippets tools
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        cmp = require("cmp")
        luasnip = require("luasnip")
        lspkind = require("lspkind")

        cmp.setup({
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer", keyword_length = 3 },
                { name = "path" },
            }),

            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if luasnip.expandable() then
                            luasnip.expand()
                        elseif cmp.get_active_entry() then
                            cmp.confirm({select = true})
                        else fallback()
                        end
                    else
                        fallback()
                    end
                end),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if #cmp.get_entries() == 1 then
                            cmp.confirm({ select = true })
                        else
                            cmp.select_next_item()
                        end
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),

            -- formatting = {
            --     format = lspkind.cmp_format({
            --         mode = "symbol_text",
            --         menu = {
            --             buffer = "[Buffer]",
            --             nvim_lsp = "[LSP]",
            --             luasnip = "[LuaSnip]",
            --             nvim_lua = "[Lua]",
            --             latex_symbols = "[Latex]",
            --         },
            --     }),
            -- },

            window = {
                completion = {
                    border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
                },

                documentation = {
                    border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
                },
            },
        })

        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                    { name = 'cmdline' }
                }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })
    end,
}
