-- AI assistants and code generation tools
vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab cC CodeCompanion]])
vim.cmd([[cab Cc CodeCompanion]])
vim.cmd([[cab CC CodeCompanion]])

return {
    -- zbirenbaum/copilot.lua: GitHub Copilot for AI code suggestions
    {
        "zbirenbaum/copilot.lua",

        opts = {
            copilot_model = "gpt-4o-copilot",
            suggestion = {
                auto_trigger = false,
                debounce = 20,
                keymap = {
                    accept = "<C-r>",
                },
            },
        },
    },

    -- olimorris/codecompanion.nvim: AI chat interface for code assistance
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },

        opts = {
            strategies = {
                chat = {
                    keymaps = {
                        send = {
                            modes = { n = "<cr>", i = "<cr>" },
                        },
                    },
                },
            },

            display = {
                chat = {
                    auto_scroll = false,
                    -- start_in_insert_mode = true,
                    window = {
                        layout = "float",
                        position = "top",
                        width = 0.7,
                        height = 0.9,
                    },
                },
            },
        },

        keys = {
            { "<leader>a", "", desc = "+IA actions", mode = { "n", "v" } },
            -- { "<c-a>", "<cmd>CodeCompanionChat Toggle<cr>", mode = "n", desc = "Toggle Code Companion Chat" },
            -- { "<c-a>", "<cmd>CodeCompanionChat Toggle<cr><esc>", mode = "i", desc = "Toggle Code Companion Chat" },
            { "<leader>aa", "<cmd>CodeCompanionAction<cr>", mode = { "n", "v" }, desc = "Code Companion Action" },
            { "<leader>ai", ":CodeCompanion ", desc = "Insert Code Companion" },
            { "<leader>ai", ":'<,'>CodeCompanion ", mode = "v", desc = "Insert Code Companion" },
            { "<leader>ac", "<cmd>CodeCompanion /commit<cr>", desc = "Insert Code Companion" },
            { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to Code Companion" },
        },
    },

    -- NickvanDyke/opencode.nvim: Interactive AI assistant with terminal integration
    {
        "NickvanDyke/opencode.nvim",
        dependencies = {
            { "folke/snacks.nvim" },
        },
        config = function()
            vim.g.opencode_opts = {
                terminal = {
                    win = {
                        position = "float",
                        enter = true,
                    },
                },
            }

            -- Required for `opts.auto_reload`
            vim.opt.autoread = true

            -- Keymaps
            vim.keymap.set({ "n", "i", "t" }, "<C-a>", function()
                require("opencode").toggle()
            end, { desc = "Toggle opencode" })
            vim.keymap.set("n", "<leader>oA", function()
                require("opencode").ask()
            end, { desc = "Ask opencode" })
            vim.keymap.set("n", "<leader>oa", function()
                require("opencode").ask("@cursor: ")
            end, { desc = "Ask opencode about this" })
            vim.keymap.set("v", "<leader>oa", function()
                require("opencode").ask("@selection: ")
            end, { desc = "Ask opencode about selection" })
            vim.keymap.set("n", "<leader>on", function()
                require("opencode").command("session_new")
            end, { desc = "New opencode session" })
            vim.keymap.set("n", "<leader>oy", function()
                require("opencode").command("messages_copy")
            end, { desc = "Copy last opencode response" })
            vim.keymap.set("n", "<S-C-u>", function()
                require("opencode").command("messages_half_page_up")
            end, { desc = "Messages half page up" })
            vim.keymap.set("n", "<S-C-d>", function()
                require("opencode").command("messages_half_page_down")
            end, { desc = "Messages half page down" })
            vim.keymap.set({ "n", "v" }, "<leader>os", function()
                require("opencode").select()
            end, { desc = "Select opencode prompt" })
            vim.keymap.set("n", "<leader>oe", function()
                require("opencode").prompt("Explain @cursor and its context")
            end, { desc = "Explain this code" })
        end,
    },
}
