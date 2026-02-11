-- Lightweight wrapper around folke/snacks.nvim to: track last terminal,
-- toggle the last terminal, and present a `vim.ui.select` picker for all
-- snacks terminals.

local Snacks = require("snacks")
local M = { last = nil, seq = 0 }

-- Constants
local BUFFER_VAR_TERMINAL = "snacks_terminal"
local BUFFER_VAR_TITLE = "snacks_term_title"
local BUFFER_VAR_CWD = "snacks_term_cwd"
local DEFAULT_TERMINAL_NAME = "terminal"
local FALLBACK_TERMINAL_NAME = "General"
local DEFER_DELAY_MS = 10
local DEFAULT_PROMPT_OPTS = {
    prompt = "Terminal name",
    default = DEFAULT_TERMINAL_NAME,
}
local FALLBACK_OPTS = {
    interactive = true,
    new = true,
    name = FALLBACK_TERMINAL_NAME,
}

-- Utility functions

local function _shallow_copy(original_table)
    if type(original_table) ~= "table" then
        return original_table
    end
    local result = {}
    for key, value in pairs(original_table) do
        result[key] = value
    end
    return result
end

local function _get_buffer_variable(buffer, name)
    local loaded, value = pcall(vim.api.nvim_buf_get_var, buffer, name)
    if loaded then
        return value
    end
    return nil
end

local function _format_command_title(command)
    if type(command) == "table" then
        return table.concat(command, " ")
    end
    return tostring(command)
end

-- State management functions

local function _set_last(terminal_state)
    M.last = M.last or {}
    M.last.win = terminal_state.win
    M.last.cmd = _shallow_copy(terminal_state.cmd)
    M.last.opts = _shallow_copy(terminal_state.opts or {})
    if not terminal_state.win then
        M.last.win = nil
    end
end

local function _save_last(command, opts)
    _set_last({ win = nil, cmd = command, opts = opts or {} })
end

local function _save_last_from_win(win, meta)
    if meta then
        _set_last({
            win = win,
            cmd = meta.cmd,
            opts = { count = meta.id, cwd = meta.cwd, env = meta.env },
        })
        return
    end

    _set_last({ win = win, cmd = win.cmd, opts = win.opts or {} })
end

-- Terminal operation helpers

local function _apply_metadata(term, next_opts, cmd)
    local meta_loaded, meta = pcall(vim.api.nvim_buf_get_var, term.buf, BUFFER_VAR_TERMINAL)
    if not meta_loaded or type(meta) ~= "table" then
        meta = {}
    end
    if next_opts.title then
        meta.title = next_opts.title
        pcall(vim.api.nvim_buf_set_var, term.buf, BUFFER_VAR_TITLE, next_opts.title)
    end
    if next_opts.cwd then
        meta.cwd = next_opts.cwd
        pcall(vim.api.nvim_buf_set_var, term.buf, BUFFER_VAR_CWD, next_opts.cwd)
    end
    if meta.cmd == nil and cmd ~= nil then
        meta.cmd = cmd
    end
    if meta.id == nil and next_opts.count ~= nil then
        meta.id = next_opts.count
    end
    pcall(vim.api.nvim_buf_set_var, term.buf, BUFFER_VAR_TERMINAL, meta)
    return meta
end

local function _open_terminal(cmd, terminal_opts)
    if not terminal_opts.cwd then
        terminal_opts.cwd = vim.fn.getcwd()
    end
    local term = Snacks.terminal.open(cmd, terminal_opts)
    if term then
        if type(term.buf) ~= "number" then
            _save_last_from_win(term, nil)
            return term
        end
        local meta = _apply_metadata(term, terminal_opts, cmd)
        vim.defer_fn(function()
            if type(term.buf) == "number" and vim.api.nvim_buf_is_valid(term.buf) then
                _apply_metadata(term, terminal_opts, cmd)
            end
        end, DEFER_DELAY_MS)
        _save_last_from_win(term, meta)
    else
        _save_last(cmd, terminal_opts)
    end
    return term
end

local function _toggle_saved_instance()
    local last = M.last
    if not last or not last.win then
        return false
    end
    if type(last.win.toggle) ~= "function" or not last.win:buf_valid() then
        return false
    end
    pcall(function()
        last.win:toggle()
    end)
    return true
end

local function _toggle_by_command()
    local last = M.last
    if not last or not last.cmd then
        return false
    end
    local loaded, term = pcall(function()
        return Snacks.terminal.get(last.cmd, last.opts)
    end)
    if loaded and term then
        pcall(function()
            term:toggle()
        end)
        return true
    end
    return false
end

-- Terminal picker helpers

local function _extract_cwd(meta, win)
    local buf_cwd = _get_buffer_variable(win.buf, BUFFER_VAR_CWD)
    if buf_cwd then
        return tostring(buf_cwd)
    end
    if meta and meta.cwd then
        return tostring(meta.cwd)
    end
    return (win.opts and win.opts.cwd) or ""
end

local function _extract_title(meta, win)
    local buf_title = _get_buffer_variable(win.buf, BUFFER_VAR_TITLE)
    if buf_title then
        return tostring(buf_title)
    end
    if meta and meta.title then
        return meta.title
    end
    if meta and meta.cmd then
        return _format_command_title(meta.cmd)
    end
    if win.opts and win.opts.title then
        return win.opts.title
    end
    if win.term_title then
        return win.term_title
    end
    if win.cmd then
        return _format_command_title(win.cmd)
    end
    return DEFAULT_TERMINAL_NAME
end

local function _format_label(meta, win)
    local title = _extract_title(meta, win)
    local cwd = _extract_cwd(meta, win)
    local short_cwd = cwd ~= "" and (" — " .. vim.fn.fnamemodify(cwd, ":~")) or ""
    return string.format("%s%s", title, short_cwd)
end

-- Public API

function M.open(cmd, opts)
    opts = opts or {}

    if opts.new then
        M.seq = M.seq + 1
        opts.count = M.seq
        opts.new = nil

        if opts.name then
            opts.title = opts.name
            return _open_terminal(cmd, opts)
        end

        vim.ui.input(DEFAULT_PROMPT_OPTS, function(input)
            local name = input or ""
            if name == "" then
                name = DEFAULT_TERMINAL_NAME
            end
            opts.title = name
            _open_terminal(cmd, opts)
        end)
        return nil
    end

    return _open_terminal(cmd, opts)
end

function M.toggle_last()
    local function open_fallback()
        M.open(nil, FALLBACK_OPTS)
    end

    if not M.last then
        open_fallback()
        return
    end

    if _toggle_saved_instance() then
        return
    end

    if _toggle_by_command() then
        return
    end

    open_fallback()
end

function M.pick()
    local list_loaded, list = pcall(function()
        return Snacks.terminal.list()
    end)
    if not list_loaded or not list or #list == 0 then
        vim.notify("No snacks terminals found", vim.log.levels.INFO)
        return
    end

    local items = {}
    for i, win in ipairs(list) do
        local meta_loaded, meta = pcall(vim.api.nvim_buf_get_var, win.buf, BUFFER_VAR_TERMINAL)
        if not meta_loaded then
            meta = nil
        end
        local label = _format_label(meta, win)
        table.insert(items, { label = label, win = win, meta = meta })
    end

    vim.ui.select(items, {
        prompt = "Select terminal",
        format_item = function(item)
            return item.label
        end,
    }, function(choice)
        if not choice then
            return
        end

        local terminal_win = choice.win
        local meta = choice.meta

        if type(terminal_win.show) == "function" then
            pcall(function()
                terminal_win:show()
            end)
        elseif type(terminal_win.toggle) == "function" then
            pcall(function()
                terminal_win:toggle()
            end)
        else
            pcall(function()
                Snacks.terminal.toggle(terminal_win.cmd, terminal_win.opts)
            end)
        end

        _save_last_from_win(terminal_win, meta)
    end)
end

function M.setup_mappings(opts)
    opts = opts or {}
    local leader = opts.leader or "<leader>"
    local map = vim.keymap.set

    map("n", leader .. "tT", function()
        M.pick()
    end, { desc = "Select snacks terminal" })
    map("n", leader .. "tn", function()
        M.open(nil, { interactive = true, new = true })
    end, { desc = "New snacks terminal" })
end

return M
