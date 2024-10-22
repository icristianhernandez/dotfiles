return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        keys = {
            { "<leader>ac", ":CopilotChatOpen<CR>", desc = "Open Copilot Chat" },
            {
                "<leader>aE",
                function()
                    require("CopilotChat").open({
                        window = {
                            layout = "float",
                            relative = "cursor",
                            width = 1,
                            height = 0.4,
                            row = 1,
                        },
                    })
                end,
                mode = { "n", "v" },
                desc = "Open Copilot Chat Inline",
            },

            -- {
            --     "<leader>aj",
            --     function()
            --         local actions = require("CopilotChat.actions")
            --         require("CopilotChat.integrations.telescope").pick(actions.help_actions())
            --     end,
            --     mode = { "n", "v" },
            --     { desc = "CopilotChat - Help actions" },
            -- },
            {
                "<leader>aI",
                function()
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
                end,
                mode = { "n", "v" },
                desc = "CopilotChat - Prompt actions",
            },
        },
        config = function()
            require("CopilotChat").setup({
                debug = true, -- Enable debugging
                auto_insert_mode = false,
                insert_at_end = true,
                window = { layout = "float", width = 0.75, height = 0.75 },
            })
            require("CopilotChat.integrations.cmp").setup()
        end,
    },
}
