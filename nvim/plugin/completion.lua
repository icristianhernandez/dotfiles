vim.pack.add({
    "https://github.com/rafamadriz/friendly-snippets",
    {
        src = "https://github.com/L3MON4D3/LuaSnip",
        version = vim.version.range("2.*"),
    },
})
vim.pack.add({
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("1.*"),
    },
})

vim.keymap.set("s", "<BS>", "<C-O>s")

require("luasnip").setup({
    loaders_store_source = false,
    update_events = { "InsertLeave", "TextChangedI" },
    history = true,
    delete_check_events = "TextChanged",
})
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({
    paths = { vim.fn.stdpath("config") .. "/snippets" },
})

require("blink.cmp").setup({
    snippets = { preset = "luasnip" },
    keymap = {
        preset = "none",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-e>"] = { "show", "hide", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },

    signature = {
        enabled = true,
        trigger = {
            show_on_keyword = true,
            show_on_insert = true,
        },
    },

    completion = {
        menu = {
            -- testing that:
            auto_show_delay_ms = 0,
            max_height = 8,
            draw = {
                columns = { { "label", "label_description", gap = 1 }, { "kind_icon", gap = 1, "kind" } },
            },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 10 },

        list = { selection = { preselect = false, auto_insert = false } },

        keyword = { range = "full" },
        ghost_text = { enabled = true },

        trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_backspace = true,
            show_on_insert = true,
            show_on_trigger_character = true,
            show_on_accept_on_trigger_character = true,
            show_on_insert_on_trigger_character = true,
            -- show_on_keyword = true,
            -- show_on_insert = true,
            -- show_on_backspace = true,
            -- show_on_backspace_after_insert_enter = true,
            -- show_on_backspace_in_keyword = true,
            -- show_on_backspace_after_accept = true,
        },
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },

        providers = {
            lsp = {
                name = "LSP",
                module = "blink.cmp.sources.lsp",
                transform_items = function(_, items)
                    local kinds = require("blink.cmp.types").CompletionItemKind

                    return vim.tbl_filter(function(item)
                        return item.kind ~= kinds.Snippet
                    end, items)
                end,

                override = {
                    get_trigger_characters = function(self)
                        local trigger_characters = self:get_trigger_characters()
                        -- vim.list_extend(trigger_characters, { "\n", "\t", " ", "-" })
                        vim.list_extend(trigger_characters, { "\n", "\t", " ", "-" })
                        return trigger_characters
                    end,
                },
            },
        },
    },

    cmdline = {
        enabled = false,
    },
})
