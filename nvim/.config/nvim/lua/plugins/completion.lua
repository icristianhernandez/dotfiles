-- Completion engine configuration
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
    -- saghen/blink.cmp: Fast and feature-rich completion engine
    {
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
                trigger = {
                    show_on_blocked_trigger_characters = {},
                    show_on_insert = true,
                    show_on_backspace_in_keyword = true,
                },
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
                providers = {
                    lsp = {
                        override = {
                            get_trigger_characters = function(self)
                                local trigger_characters = self:get_trigger_characters()
                                local char_groups = {
                                    newline = { "\n", "\r\n" },
                                    tab = { "\t" },
                                    space = { " " },
                                    dash = { "-" },
                                }

                                for _, chars in pairs(char_groups) do
                                    vim.list_extend(trigger_characters, chars)
                                end

                                return trigger_characters
                            end,
                        },
                    },
                },
            },
        },
    },
}
