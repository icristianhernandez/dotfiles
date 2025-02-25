-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")

-- clear signcolumn background color
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    pattern = { "*" },
    callback = function()
        vim.cmd("hi clear SignColumn")
    end,
})

-- Auto insert when enter a terminal window
-- vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
--     pattern = { "*" },
--     callback = function()
--         if vim.opt.buftype:get() == "terminal" then
--             vim.cmd(":startinsert")
--         end
--     end,
-- })

-- disable auto comment
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*" },
    callback = function()
        -- vim.opt_local.formatoptions:remove("c")
        -- vim.opt_local.formatoptions:remove("r")
        vim.opt_local.formatoptions:remove("o")
    end,
})
