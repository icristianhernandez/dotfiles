local tools = require("extra.tools_handler")

vim.pack.add({
    "https://github.com/mfussenegger/nvim-lint",
})

local linters = tools.resolve("linters")

local lint = require("lint")
lint.linters_by_ft = linters.linters_by_ft

local lint_augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = lint_augroup,
    callback = function()
        lint.try_lint()
    end,
})

vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
        if vim.bo.modified then
            lint.try_lint()
        end
    end,
})

vim.keymap.set("n", "<leader>cl", function()
    lint.try_lint()
    vim.notify("Linting triggered", vim.log.levels.INFO)
end, { desc = "Trigger linting" })
