-- open help file in the current window
-- translating: command! -nargs=1 -complete=help H :enew | :set buftype=help | :keepalt h <args>
-- adding support to invalid help tags
vim.api.nvim_create_user_command("H", function(opts)
    local prior_buf_id = vim.api.nvim_get_current_buf()
    local prior_alt_buf_id = vim.fn.bufnr("#")
    local prior_buf_type = vim.api.nvim_buf_get_option(prior_buf_id, "buftype")

    vim.cmd("enew")
    local help_buf_id = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(help_buf_id, "buftype", "help")

    local success, err = pcall(vim.cmd, "h " .. opts.fargs[1])
    if not success then
        vim.api.nvim_set_current_buf(prior_buf_id)
        vim.fn.setreg("#", prior_alt_buf_id)
        vim.api.nvim_buf_delete(help_buf_id, { force = true })
        vim.api.nvim_set_current_buf(prior_buf_id)
        vim.notify(err, vim.log.levels.WARN)
        -- elseif prior_buf_type == "help" then
        --     vim.fn.setreg("#", prior_alt_buf_id)
    end

    if prior_buf_type == "help" then
        vim.fn.setreg("#", prior_alt_buf_id)
    end
end, {
    nargs = 1,
    complete = "help",
})

vim.cmd("cnoreabbrev <expr> h ((getcmdtype() is# ':' && getcmdline() is# 'h')?('H'):('h'))")
