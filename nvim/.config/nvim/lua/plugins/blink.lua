-- To remove a snippet placeholder that doesn't go away when typing
vim.keymap.set("s", "<BS>", "<C-O>s")

---@module 'blink.cmp'
---@type blink.cmp.KeymapConfig
local blink_keymaps = {
    preset = "none",
    ["<Tab>"] = {
        function(cmp)
            if #cmp.get_items() == 1 then
                return cmp.select_and_accept()
            end
        end,
        "select_next",
        "snippet_forward",
        "fallback",
    },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<C-e>"] = { "show", "hide" },
}

return {
    -- blink.nvim: a completion engine for neovim, with a focus on speed
    -- and simplicity
    "saghen/blink.cmp",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        signature = {
            enabled = true,
            trigger = {
                show_on_keyword = true,
                show_on_insert = true,
            },
        },

        keymap = blink_keymaps,

        completion = {
            list = { selection = { preselect = false, auto_insert = true } },
            ghost_text = { enabled = false },
            menu = { auto_show = true },
            documentation = { auto_show_delay_ms = 80 },
            keyword = { range = "full" },

            -- by default, blink.cmp will block newline, tab and space trigger characters, disable that behavior
            trigger = { show_on_blocked_trigger_characters = {} },
        },

        cmdline = {
            enabled = true,
            completion = {
                list = { selection = { preselect = false, auto_insert = true } },
                ghost_text = { enabled = false },
                menu = { auto_show = true },
            },

            keymap = blink_keymaps,
        },

        sources = {
            -- add newline, tab and space to LSP source trigger characters
            providers = {
                lsp = {
                    override = {
                        get_trigger_characters = function(self)
                            local trigger_characters = self:get_trigger_characters()
                            vim.list_extend(trigger_characters, { "\n", "\t", " ", "-" })
                            return trigger_characters
                        end,
                    },
                },
            },
        },
    },
}
