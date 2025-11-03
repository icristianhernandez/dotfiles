return {
    -- saghen/blink.cmp: completion engine with custom keymaps and LSP integration
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = { "rafamadriz/friendly-snippets" },

        opts = function(_, opts)
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

            ---@module 'blink.cmp'
            ---@type blink.cmp.Config
            local new_opts = {
                signature = { enabled = true, trigger = { show_on_keyword = true, show_on_insert = true } },
                keymap = blink_keymaps,
                completion = {
                    list = { selection = { preselect = false, auto_insert = true } },
                    ghost_text = { enabled = false },
                    menu = {
                        auto_show = true,
                        draw = {
                            treesitter = { "lsp" },
                        },
                    },
                    documentation = {
                        auto_show_delay_ms = 80,
                        auto_show = true,
                    },
                    keyword = { range = "full" },
                    trigger = {
                        show_on_blocked_trigger_characters = {},
                        show_on_insert = true,
                        show_on_backspace_in_keyword = true,
                    },
                    accept = {
                        auto_brackets = {
                            enabled = true,
                        },
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
                    per_filetype = {
                        lua = { inherit_defaults = true, "lazydev" },
                    },

                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            score_offset = 100, -- show at a higher priority than lsp
                        },

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
            }

            return vim.tbl_deep_extend("force", opts or {}, new_opts)
        end,
    },
}
