return {
    {
        -- zbirenbaum/copilot.lua: copilot lsp + auth + inline suggestions
        "zbirenbaum/copilot.lua",
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
        },
    },
    {
        -- NickvanDyke/opencode.nvim: AI-powered coding assistant
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
                    enabled = "snacks",
                    snacks = { win = { position = "float", enter = true } },
                },
                contexts = {
                    ["@staged_diff"] = function()
                        local handle = io.popen("git --no-pager diff --staged")
                        if not handle then
                            return nil
                        end
                        local result = handle:read("*a")
                        handle:close()
                        if result and result ~= "" then
                            return result
                        end
                        return nil
                    end,
                },
                prompts = {
                    commit_from_unstaged = {
                        prompt = "Review the current git unstaged changes: @diff\nWrite a commit msg based on Conventional Commits.\n\nDo NOT execute commands. I can (A) produce message only, (B) show exact git commands, or (C) run the commands. Reply A, B, or C. If you choose C, confirm with: Confirm: <exact command>",
                        submit = true,
                    },
                    commit_from_staged = {
                        prompt = "Review the current git staged changes: @staged_diff\nWrite a commit msg based on Conventional Commits.\n\nDo NOT execute commands. I can (A) produce message only, (B) show exact git commands, or (C) run the commands. Reply A, B, or C. If you choose C, confirm with: Confirm: <exact command>",
                        submit = true,
                    },
                },
            }

            -- Recommended/example keymaps.
            vim.keymap.set({ "n", "x" }, "<leader>aa", function()
                require("opencode").ask("@this: ", { submit = true })
            end, { desc = "Ask opencode" })
            vim.keymap.set({ "n", "x" }, "<leader>ap", function()
                require("opencode").select()
            end, { desc = "Execute opencode action…" })
            vim.keymap.set({ "n", "x" }, "<leader>ac", function()
                require("opencode").prompt("commit_from_staged", { submit = true })
            end, { desc = "opencode: commit from unstaged" })
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
