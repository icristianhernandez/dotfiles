-- To remove an snippet placeholder that doesn't go away when typing
vim.keymap.set("s", "<BS>", "<C-O>s")

if vim.fn.has("nvim-0.11") == 1 then
    -- Ensure that forced and not configurable `<Tab>` and `<S-Tab>`
    -- buffer-local mappings don't override already present ones
    local expand_orig = vim.snippet.expand
    vim.snippet.expand = function(...)
        local tab_map = vim.fn.maparg("<Tab>", "i", false, true)
        local stab_map = vim.fn.maparg("<S-Tab>", "i", false, true)
        expand_orig(...)
        vim.schedule(function()
            tab_map.buffer, stab_map.buffer = 1, 1
            -- Override temporarily forced buffer-local mappings
            vim.fn.mapset("i", false, tab_map)
            vim.fn.mapset("i", false, stab_map)
        end)
    end
else
    -- report message than an cmp patch is being used and only enabled in nvim 0.11
    -- vim.notify_once("cmp patch is being used and only enabled in nvim 0.11", "warn")
    vim.notify_once("cmp patch is being used and only enabled in nvim 0.11", vim.log.levels.INFO)
end

return {
    "saghen/blink.cmp",

    opts = {
        signature = {
            enabled = true,
            trigger = {
                show_on_keyword = true,
                show_on_insert = true,
            },
        },

        keymap = {
            preset = "none",
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
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
            completion = {
                list = { selection = { preselect = false, auto_insert = true } },
                ghost_text = { enabled = false },
                menu = { auto_show = true },
            },

            keymap = {
                preset = "none",
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
            },

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

        term = {
            enabled = true,
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
