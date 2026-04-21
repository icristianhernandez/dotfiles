-- BUG: for some reason, overseer crashes when is loaded before auto session, I
-- think...

vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
})

vim.pack.add({
    "https://github.com/stevearc/overseer.nvim",
})

local overseer = require("overseer")

overseer.setup()

local auto_commit_script = vim.fn.expand("~/dotfiles/scripts/git-auto-commit-opencode.sh")
if vim.fn.filereadable(auto_commit_script) == 1 then
    overseer.register_template({
        name = "Auto Commit",
        desc = "Run git auto-commit script",
        builder = function()
            return {
                cmd = { auto_commit_script },
                components = { "default" },
            }
        end,
    })
end

vim.keymap.set("n", "<leader>ac", function()
    overseer.run_task({ name = "Auto Commit" })
end, { desc = "Auto-commit" })

vim.keymap.set("n", "<leader>tr", function()
    require("overseer.template").list({
        dir = vim.fn.getcwd(),
        filetype = vim.bo.filetype,
    }, function(templates)
        templates = vim.tbl_filter(function(t)
            return not t.hide
        end, templates)
        if #templates == 0 then
            return vim.notify("No tasks", vim.log.levels.WARN)
        end
        vim.ui.select(templates, {
            prompt = "Task:",
            format_item = function(t)
                return t.desc and string.format("%s (%s)", t.name, t.desc) or t.name
            end,
        }, function(t)
            if t then
                overseer.run_task({ name = t.name })
            end
        end)
    end)
end, { desc = "Run task" })

vim.keymap.set("n", "<leader>tt", "<cmd>OverseerToggle<cr>", { desc = "Toggle overseer" })
