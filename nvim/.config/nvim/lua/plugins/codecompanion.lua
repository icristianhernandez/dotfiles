vim.cmd([[cab cc CodeCompanion]])
vim.cmd([[cab cC CodeCompanion]])
vim.cmd([[cab Cc CodeCompanion]])
vim.cmd([[cab CC CodeCompanion]])

return {
    -- codecompanion.nvim: a Neovim plugin that provides a chat interface for
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
}
