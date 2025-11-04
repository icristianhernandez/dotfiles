-- AI assistants & ops: Copilot and opencode.nvim
return {
    {
        -- zbirenbaum/copilot.lua: copilot lsp + auth + inline suggestions
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            panel = {enabled = false},
            suggestion = {
                hide_during_completion = false,
                debounce = 0,
                keymap = {accept = "<C-r>"}
            }
        }
    },
    {
        "folke/sidekick.nvim",
        keys = {
            {
                "<C-r>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<C-r>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion"
            }
        }
    },
    {
        "NickvanDyke/opencode.nvim",
        dependencies = {
            -- Recommended for `ask()` and `select()`.
            -- Required for default `toggle()` implementation.
            {"folke/snacks.nvim", opts = {input = {}, picker = {}, terminal = {}}}

        },
        config = function()
            ---@type opencode.Opts
            vim.g.opencode_opts = {
                terminal = {win = {position = "float", enter = true}}
            }

            -- Required for `opts.auto_reload`.
            vim.o.autoread = true

            -- Recommended/example keymaps.
            vim.keymap.set(
                {"n", "x"},
                "<leader>aa",
                function()
                    require("opencode").ask("@this: ", {submit = true})
                end,
                {desc = "Ask opencode"}
            )
            vim.keymap.set(
                {"n", "x"},
                "<C-x>",
                function()
                    require("opencode").select()
                end,
                {desc = "Execute opencode action…"}
            )
            vim.keymap.set(
                {"n", "x"},
                "ga",
                function()
                    require("opencode").prompt("@this")
                end,
                {desc = "Add to opencode"}
            )
            vim.keymap.set(
                {"n", "t"},
                "<C-a>",
                function()
                    require("opencode").toggle()
                end,
                {desc = "Toggle opencode"}
            )
            vim.keymap.set(
                "n",
                "<S-C-u>",
                function()
                    require("opencode").command("session.half.page.up")
                end,
                {desc = "opencode half page up"}
            )
            vim.keymap.set(
                "n",
                "<S-C-d>",
                function()
                    require("opencode").command("session.half.page.down")
                end,
                {desc = "opencode half page down"}
            )
        end
    }
}

