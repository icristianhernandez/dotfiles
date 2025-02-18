vim.keymap.set("s", "<BS>", "<C-O>s")

return {
    "saghen/blink.cmp",
    enabled = true,

    opts = {
        signature = { enabled = true },

        keymap = {
            -- preset = "super-tab",
            preset = "none",
            ["<CR>"] = { "accept", "fallback" },
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        },

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
            sources = function()
                local type = vim.fn.getcmdtype()
                -- Search forward and backward
                if type == "/" or type == "?" then
                    return { "buffer" }
                end
                -- Commands
                if type == ":" or type == "@" then
                    return { "cmdline" }
                end
                return {}
            end,
        },

        sources = {
            -- add newline, tab and space to LSP source trigger characters
            providers = {
                lsp = {
                    override = {
                        get_trigger_characters = function(self)
                            local trigger_characters = self:get_trigger_characters()
                            vim.list_extend(trigger_characters, { "\n", "\t", " " })
                            return trigger_characters
                        end,
                    },
                },
            },
        },
    },
}
