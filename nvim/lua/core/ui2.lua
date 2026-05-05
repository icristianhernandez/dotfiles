local ui = require("vim._core.ui2")
local messages = require("vim._core.ui2.messages")

local MAX_WIDTH_RATIO = 0.3

ui.enable({
    enable = true,
    msg = {
        targets = {
            [""] = "msg",
            bufwrite = "msg",
            completion = "msg",
            echo = "msg",
            echomsg = "msg",
            echoerr = "msg",
            emsg = "msg",
            empty = "msg",
            lua_error = "msg",
            lua_print = "msg",
            progress = "msg",
            quickfix = "msg",
            rpc_error = "msg",
            search_cmd = "msg",
            search_count = "msg",
            shell_cmd = "msg",
            shell_err = "msg",
            shell_out = "msg",
            shell_ret = "msg",
            typed_cmd = "msg",
            undo = "msg",
            wildlist = "msg",
            wmsg = "msg",

            confirm = "dialog",
            confirm_sub = "dialog",

            list_cmd = "pager",
            verbose = "pager",
        },
        cmd = { height = 0.5 },
        dialog = { height = 0.5 },
        msg = {
            height = 0.8,
            timeout = 5000,
        },
        pager = { height = 0.5 },
    },
})

local skip_messages = {
    -- Write
    "%d+L, %d+B",

    -- Search
    "; after #%d+",
    "; before #%d+",
    "^[/?].*",
    "E486: Pattern not found:",

    -- Edit
    "%d+ less lines",
    "%d+ fewer lines",
    "%d+ more lines",
    "%d+ change;",
    "%d+ line less;",
    "%d+ more lines?;",
    "%d+ fewer lines;?",
    "1 more line",
    "1 line less",
    "^Hunk %d+ of %d+$",
    "Already at newest change",
    "Already at oldest change",

    "%d lines yanked",
    "no lines in buffer",

    -- Undo/Redo
    "%d+ changes?;",
    " changes; brefore #",
    " changes; after #",
    " 1 change; before #",
    " 1 change; after #",

    -- Move lines
    " lines moved",
    " lines indented",
}

local normalized_content = function(src)
    if type(src) ~= "table" then
        return tostring(src or "")
    end

    local list = {}
    for _, chunk in ipairs(src) do
        if type(chunk) == "table" and chunk[2] then
            list[#list + 1] = chunk[2]
        end
    end

    return table.concat(list)
end

local o_msg_show = messages.msg_show

messages.msg_show = function(kind, content, replace_last, history, append, id, trigger)
    if kind == "bufwrite" then
        return
    end

    local msg = normalized_content(content)

    for _, pat in ipairs(skip_messages) do
        if msg:find(pat) then
            return
        end
    end

    messages.msg.width = 1
    o_msg_show(kind, content, replace_last, history, append, id, trigger)
end

-- Message window positioning
local o_api = vim.api

local function ui2_max_width()
    return math.floor(vim.o.columns * MAX_WIDTH_RATIO)
end

local function position_msg_win(cfg)
    cfg.relative = "editor"
    cfg.anchor = "NE"
    cfg.row = 0
    cfg.col = vim.o.columns
    cfg.border = "single"
end

local function recalc_msg_width()
    local buf, win = ui.bufs.msg, ui.wins.msg
    if not o_api.nvim_buf_is_valid(buf) then
        return
    end
    if not o_api.nvim_win_is_valid(win) then
        return
    end
    if o_api.nvim_win_get_config(win).hide then
        return
    end

    local max_w = 0
    for _, line in ipairs(o_api.nvim_buf_get_lines(buf, 0, -1, false)) do
        max_w = math.max(max_w, vim.fn.strdisplaywidth(line))
    end
    if max_w == 0 then
        o_api.nvim_win_set_config(win, { hide = true })
        return
    end
    messages.msg.width = max_w
    max_w = math.min(max_w + 2, ui2_max_width())
    o_api.nvim_win_set_width(win, max_w)
end

local orig_open_win = o_api.nvim_open_win
o_api.nvim_open_win = function(buf, enter, cfg)
    if buf == ui.bufs.msg then
        position_msg_win(cfg)
        cfg.width = math.min(cfg.width or 10000, ui2_max_width())

        if not vim.b[buf].ui2_width_attached then
            vim.b[buf].ui2_width_attached = true
            o_api.nvim_buf_attach(buf, false, {
                on_lines = function()
                    vim.schedule(recalc_msg_width)
                end,
            })
        end
    end
    return orig_open_win(buf, enter, cfg)
end

local orig_set_config = o_api.nvim_win_set_config
o_api.nvim_win_set_config = function(win, cfg)
    if win == ui.wins.msg and not cfg.win and cfg.hide ~= true then
        position_msg_win(cfg)
        if cfg.width then
            cfg.width = math.min(cfg.width, ui2_max_width())
        end
    end
    return orig_set_config(win, cfg)
end

local orig_set_width = o_api.nvim_win_set_width
o_api.nvim_win_set_width = function(win, width)
    if win == ui.wins.msg then
        width = math.min(width, ui2_max_width())
    end
    return orig_set_width(win, width)
end
