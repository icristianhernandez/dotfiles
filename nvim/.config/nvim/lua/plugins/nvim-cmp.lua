return {
    -- nvim-cmp: autocompletion

    -- "hrsh7th/nvim-cmp",
    -- changed for a better performance fork
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    lazy = false,

    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-cmdline",
        "onsails/lspkind.nvim",
        -- snippets tools
        {
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
            dependencies = {
                "saadparwaiz1/cmp_luasnip",
                "rafamadriz/friendly-snippets",
            },
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
    },

    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        require("extras.cmp_completion_hl")

        vim.keymap.set("s", "<BS>", "<C-O>s")

        cmp.setup({
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer", keyword_length = 3 },
                { name = "nvim_lua" },
                { name = "path" },
            }),

            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },

            view = {
                entries = { selection_order = "near_cursor" },
            },

            window = {
                completion = {
                    -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                    col_offset = -3,
                    side_padding = 0,
                    -- border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
                },
                documentation = {
                    border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
                },
            },

            performance = {
                throttle = 0,
                debounce = 0,
                fetching_timeout = 0,
                -- async_budget = 1000,
                -- max_view_entries = 10,
            },

            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    kind.kind = " " .. (strings[1] or "") .. " "

                    -- selection type
                    kind.menu = "     " .. (strings[2] or "") .. " " --

                    -- source
                    -- kind.menu = "    [" .. entry.source.name .. "]"

                    -- merge filetypes and source
                    -- kind.menu = "    (" .. (strings[2] or "") .. ") [" .. entry.source.name .. "] "
                    return kind
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if luasnip.expandable() then
                            luasnip.expand()
                        elseif cmp.get_active_entry() then
                            cmp.confirm({ select = true })
                        else
                            fallback()
                        end
                    else
                        fallback()
                    end
                end, { "i" }),
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
        })

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline({
                -- ["<CR>"] = cmp.mapping(
                --     function(fallback)
                --         if cmp.visible() then
                --             if luasnip.expandable() then
                --                 luasnip.expand()
                --             elseif cmp.get_active_entry() then
                --                 cmp.confirm({select = true})
                --             else
                --                 fallback()
                --             end
                --         else
                --             fallback()
                --         end
                --     end,
                --     { "c" }
                -- ),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if #cmp.get_entries() == 1 then
                            cmp.confirm({ select = true })
                        else
                            cmp.select_next_item()
                        end
                    else
                        fallback()
                    end
                end, { "c" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "c" }),
            }),

            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),

            matching = { disallow_symbol_nonprefix_matching = false },
        })
    end,
}
