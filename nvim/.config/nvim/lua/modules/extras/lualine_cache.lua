local M = {}

local function compute_parent_path(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if not bufname or bufname == "" then
        return ""
    end

    local rel = vim.fn.fnamemodify(bufname, ':.')
    local rel_dir = vim.fn.fnamemodify(rel, ':h')
    if not rel_dir or rel_dir == '' or rel_dir == '.' then
        return ''
    end

    rel_dir = rel_dir:gsub('\\', '/')
    local comps = {}
    for part in rel_dir:gmatch('[^/]+') do
        table.insert(comps, part)
    end

    if #comps <= 1 then
        return ''
    end

    table.remove(comps, #comps)
    return table.concat(comps, '/')
end

function M.update(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local ok, val = pcall(compute_parent_path, bufnr)
    if not ok then
        val = ''
    end

    -- set buffer-local value for current buffer for fast access
    local cur = vim.api.nvim_get_current_buf()
    if bufnr == cur then
        vim.b.lualine_cached_parent_path = val
    end

    -- also persist as a buffer variable so it can be read when buffer is not current
    pcall(vim.api.nvim_buf_set_var, bufnr, 'lualine_cached_parent_path', val)
end

function M.get_parent_path(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if bufnr == vim.api.nvim_get_current_buf() then
        return vim.b.lualine_cached_parent_path or ''
    end
    local ok, val = pcall(vim.api.nvim_buf_get_var, bufnr, 'lualine_cached_parent_path')
    if ok then return val end
    return ''
end

function M.setup()
    local group = vim.api.nvim_create_augroup('LualineCache', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'BufFilePost', 'BufWritePost', 'TabEnter', 'VimResized' }, {
        group = group,
        callback = function(args)
            local bufnr = args.buf or vim.api.nvim_get_current_buf()
            M.update(bufnr)
            local ok, lualine = pcall(require, 'lualine')
            if ok and type(lualine.refresh) == 'function' then
                pcall(function()
                    lualine.refresh({ place = { 'statusline', 'tabline' }, force = false })
                end)
            end
        end,
    })

    -- Prime cache for loaded buffers
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
            M.update(bufnr)
        end
    end
end

return M
