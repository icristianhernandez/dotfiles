return {
    -- nvim-cmp: autocompletion

    -- "hrsh7th/nvim-cmp",
    -- changed for a better performance fork
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    event = "VeryLazy",

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
                max_view_entries = 10,
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
        local function hex_to_rgb(hex)
            return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
        end

        local function rgb_to_hex(r, g, b)
            return string.format("#%02x%02x%02x", r, g, b)
        end

        local function blend_color(hex_fg_color, hex_bg_color, alpha)
            local fg_r, fg_g, fg_b = hex_to_rgb(hex_fg_color)
            local bg_r, bg_g, bg_b = hex_to_rgb(hex_bg_color)

            local r = math.floor(fg_r * alpha + bg_r * (1 - alpha))
            local g = math.floor(fg_g * alpha + bg_g * (1 - alpha))
            local b = math.floor(fg_b * alpha + bg_b * (1 - alpha))

            return rgb_to_hex(r, g, b)
        end

        local function lightnen_color(hex_color, alpha)
            local r, g, b = hex_to_rgb(hex_color)

            r = math.floor(r + (255 - r) * alpha)
            g = math.floor(g + (255 - g) * alpha)
            b = math.floor(b + (255 - b) * alpha)

            return rgb_to_hex(r, g, b)
        end

        local function get_hex_fg_hl(hl_name)
            local hl = vim.api.nvim_get_hl_by_name(hl_name, true) or {}

            if not hl or not hl.foreground then
                return nil
            end

            return string.format("#%06x", hl.foreground)
        end

        local function cmp_icons_colors()
            -- vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
            -- vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

            vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { link = "Comment" })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "Search" })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "Search" })
            vim.api.nvim_set_hl(0, "CmpItemMenu", { link = "Special" })

            local hl_groups = {
                { "CmpItemKindField", "Type" },
                { "CmpItemKindProperty", "Type" },
                { "CmpItemKindEvent", "Type" },
                { "CmpItemKindText", "String" },
                { "CmpItemKindEnum", "String" },
                { "CmpItemKindKeyword", "Keyword" },
                { "CmpItemKindConstant", "Constant" },
                { "CmpItemKindConstructor", "Function" },
                { "CmpItemKindReference", "Constant" },
                { "CmpItemKindFunction", "Function" },
                { "CmpItemKindStruct", "Structure" },
                { "CmpItemKindClass", "Structure" },
                { "CmpItemKindModule", "Structure" },
                { "CmpItemKindOperator", "Operator" },
                { "CmpItemKindVariable", "Identifier" },
                { "CmpItemKindFile", "Directory" },
                { "CmpItemKindUnit", "Number" },
                { "CmpItemKindSnippet", "Special" },
                { "CmpItemKindFolder", "Directory" },
                { "CmpItemKindMethod", "Function" },
                { "CmpItemKindValue", "Number" },
                { "CmpItemKindEnumMember", "Number" },
                { "CmpItemKindInterface", "Type" },
                { "CmpItemKindColor", "Special" },
                { "CmpItemKindTypeParameter", "Type" },
            }

            for _, group in ipairs(hl_groups) do
                local fg_color = get_hex_fg_hl(group[2])
                local pmenu_bg = vim.api.nvim_get_hl_by_name("Pmenu", true).background
                pmenu_bg = string.format("#%06x", pmenu_bg)

                if fg_color then
                    -- all same colors:
                    -- fg_color = lightnen_color(fg_color, 0.45)
                    -- local bg_color = blend_color(fg_color, pmenu_bg, 0.5)
                    -- vim.api.nvim_set_hl(0, group[1], { fg = fg_color, bg = bg_color })

                    -- white fg
                    -- fg_color = lightnen_color(fg_color, 0.2)
                    -- pmenu_bg = lightnen_color(pmenu_bg, 0.2)
                    local bg_color = blend_color(fg_color, pmenu_bg, 0.4)
                    vim.api.nvim_set_hl(0, group[1], { fg = "#FFFFFF", bg = bg_color })
                end
            end
        end

        -- autocmd of the icons highlight when colorscheme changed
        cmp_icons_colors()
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                cmp_icons_colors()
            end,
        })
    end,
}
