local tools = require("extra.tools_handler")

vim.pack.add({
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mfussenegger/nvim-lint",
})

require("mason").setup()

local linters = tools.resolve("linters")
vim.defer_fn(function()
    tools.install_mason_tools(linters.ensure_installed)
end, 0)

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

vim.keymap.set("n", "<leader>cL", function()
    local running = lint.get_running()
    if #running == 0 then
        vim.notify("No linters running", vim.log.levels.INFO)
    else
        vim.notify("Running: " .. table.concat(running, ", "), vim.log.levels.INFO)
    end
end, { desc = "Show running linters" })
