-- Remove the default highlight yank autocmd group.
vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")

-- Clear the SignColumn background color on any colorscheme change.
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.cmd("hi clear SignColumn")
    end,
})

-- Disable auto-commenting for all file types.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove("o")
    end,
})
