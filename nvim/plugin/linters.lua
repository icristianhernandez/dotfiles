local tools = require("extra.tools_resolver")

vim.pack.add({
    "https://github.com/mfussenegger/nvim-lint",
})

local linters = tools.resolve("linters")

local lint = require("lint")
lint.linters_by_ft = linters.linters_by_ft

local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

local lint_timer = vim.uv.new_timer()
assert(lint_timer, "failed to create uv timer, error in 'plugin/linters.lua' ")

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
    group = lint_augroup,
    callback = function()
        if vim.bo.buftype ~= "" then
            return
        end
        lint.try_lint(nil, { ignore_errors = true })
    end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
        if vim.bo.buftype ~= "" or not vim.bo.modified then
            return
        end
        lint_timer:start(
            300,
            0,
            vim.schedule_wrap(function()
                lint.try_lint(nil, { ignore_errors = true })
            end)
        )
    end,
})

vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = lint_augroup,
    callback = function()
        if lint_timer:is_active() then
            lint_timer:stop()
        end
    end,
})

vim.keymap.set("n", "<leader>cl", function()
    lint.try_lint(nil, { ignore_errors = true })
    vim.notify("Linting triggered", vim.log.levels.INFO)
end, { desc = "Trigger linting" })
