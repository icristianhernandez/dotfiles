return {
    {
        -- zbirenbaum/copilot.lua: copilot lsp + auth + inline suggestions
        "zbirenbaum/copilot.lua",
        dependencies = {
            "copilotlsp-nvim/copilot-lsp",
        },
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            panel = { enabled = false },
            suggestion = {
                auto_trigger = false,
                hide_during_completion = false,
                debounce = 0,
                keymap = { accept = "<C-e>" },
            },
            filetypes = {
                ["*"] = true,
            },
            -- nes = {
            --     enabled = false,
            --     auto_trigger = true,
            --     keymap = {
            --         accept_and_goto = "<C-e>",
            --         dismiss = "<Esc>",
            --     },
            -- },
        },
    },
    {
        "NickvanDyke/opencode.nvim",
        dependencies = {
            {
                ---@module 'snacks'
                { "folke/snacks.nvim" },
            },
        },
        config = function()
            -- Required for `opts.auto_reload`.
            vim.o.autoread = true

            ---@type opencode.Opts
            vim.g.opencode_opts = {
                provider = {
                    name = "snacks",
                    snacks = { win = { position = "float", enter = true } },
                },
            }

            -- Recommended/example keymaps.
            vim.keymap.set({ "n", "x" }, "<leader>aa", function()
                require("opencode").ask("@this: ", { submit = true })
            end, { desc = "Ask opencode" })
            vim.keymap.set({ "n", "x" }, "<leader>ap", function()
                require("opencode").select()
            end, { desc = "Execute opencode action…" })
            vim.keymap.set({ "n", "x" }, "<leader>ao", function()
                require("opencode").prompt("@this")
            end, { desc = "Add to opencode" })
            vim.keymap.set({ "n", "t" }, "<c-a>", function()
                require("opencode").toggle()
            end, { desc = "Toggle opencode" })
            vim.keymap.set("n", "<leader>au", function()
                require("opencode").command("session.half.page.up")
            end, { desc = "opencode half page up" })
            vim.keymap.set("n", "<leader>ad", function()
                require("opencode").command("session.half.page.down")
            end, { desc = "opencode half page down" })
        end,
    },
}
