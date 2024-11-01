-- Disable highlight signs color
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
    pattern = { "*" },
    callback = function()
        vim.cmd("hi clear SignColumn")
    end,
})

-- Auto insert when enter a terminal window
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    pattern = { "*" },
    callback = function()
        if vim.opt.buftype:get() == "terminal" then
            vim.cmd(":startinsert")
        end
    end,
})

-- disable auto comment
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*" },
    callback = function()
        -- vim.opt_local.formatoptions:remove("c")
        -- vim.opt_local.formatoptions:remove("r")
        vim.opt_local.formatoptions:remove("o")
    end,
})

-- Highlight when yanking (copying) text
-- vim.api.nvim_create_autocmd('TextYankPost', {
--     desc = 'Highlight when yanking (copying) text',
--     group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--     callback = function()
--         vim.highlight.on_yank()
--     end,
-- })

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- Always get the last cursor position when opening a file
-- vim.api.nvim_create_autocmd("BufReadPost", {
--     callback = function(event)
--         local exclude = { "gitcommit" }
--         local buf = event.buf
--         if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
--             return
--         end
--         vim.b[buf].lazyvim_last_loc = true
--         local mark = vim.api.nvim_buf_get_mark(buf, '"')
--         local lcount = vim.api.nvim_buf_line_count(buf)
--         if mark[1] > 0 and mark[1] <= lcount then
--             pcall(vim.api.nvim_win_set_cursor, 0, mark)
--         end
--     end,
-- })

-- Save cursor position
local lastplace = vim.api.nvim_create_augroup("LastPlace", {})
vim.api.nvim_clear_autocmds({ group = lastplace })
vim.api.nvim_create_autocmd("BufReadPost", {
    group = lastplace,
    pattern = { "*" },
    desc = "remember last cursor place",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lines_count = vim.api.nvim_buf_line_count(0)
        local ft_exclude = { "gitcommit", "gitrebase", "svn", "hgcommit" }

        if vim.tbl_contains(ft_exclude, vim.bo.filetype) then
            return
        end

        local row_exist = mark[1] > 0 and mark[1] <= lines_count
        if not row_exist then
            return
        end

        local line_columns = #vim.api.nvim_buf_get_lines(0, mark[1] - 1, mark[1], false)[1]
        local column_exist = mark[2] >= 0 and mark[2] <= line_columns
        if not column_exist then
            return
        end

        pcall(vim.api.nvim_win_set_cursor, 0, mark)
        vim.cmd("normal! zz")
    end,
})

-- maximize split when focus on it
-- vim.api.nvim_create_autocmd("FocusGained", {
--     pattern = { "*" },
--     callback = function()
--         vim.cmd("wincmd _")
--     end,
-- })
-- vim.api.nvim_create_autocmd("FocusLost", {
--     pattern = { "*" },
--     callback = function()
--         vim.cmd("wincmd =")
--     end,
-- })
