-- Mini files layout for a Ranger/Yazi style

local MAX_HEIGHT = 15
local UI_MIN_SIZE = 10
local BORDER_PAD = 2

local MiniFiles_cache

local function get_mini_files()
    if MiniFiles_cache then
        return MiniFiles_cache
    end
    local ok, mod = pcall(require, "mini.files")
    if ok then
        MiniFiles_cache = mod
        return mod
    end
end

local function get_config_snapshot()
    local MiniFiles = get_mini_files()
    local windows = ((MiniFiles and MiniFiles.config) and MiniFiles.config.windows) or {}
    return {
        preview = windows.preview == true,
        width_nofocus = windows.width_nofocus or 15,
        width_preview = windows.width_preview or 25,
    }
end

local function apply_window_style(win_id)
    if not win_id or not vim.api.nvim_win_is_valid(win_id) then
        return
    end
    local available_height = vim.o.lines - UI_MIN_SIZE
    local config = vim.api.nvim_win_get_config(win_id)
    config.border = "rounded"
    config.title_pos = "left"
    config.height = math.min(MAX_HEIGHT, available_height)
    vim.api.nvim_win_set_config(win_id, config)
end

local function branches_equal(a, b)
    if a == b then
        return true
    end
    if type(a) ~= "table" or type(b) ~= "table" then
        return false
    end
    if #a ~= #b then
        return false
    end
    for i = 1, #a do
        if a[i] ~= b[i] then
            return false
        end
    end
    return true
end

local function get_parent_path(state, focus_path, depth_focus)
    local branch = state.branch
    local parent = branch[depth_focus - 1]
    if parent then
        return parent
    end
    local derived = vim.fs.dirname(focus_path)
    if derived and derived ~= focus_path and vim.fn.isdirectory(derived) == 1 then
        return derived
    end
end

local function get_right_path(state, depth_focus)
    local MiniFiles = get_mini_files()
    if not MiniFiles then
        return nil
    end
    local branch = state.branch
    local right = branch[depth_focus + 1]
    if right then
        return right
    end
    local fs_entry = MiniFiles.get_fs_entry()
    if fs_entry and fs_entry.path then
        if fs_entry.fs_type == "directory" then
            return fs_entry.path
        end
        local cfg = get_config_snapshot()
        if cfg.preview then
            return fs_entry.path
        end
    end
end

local placeholders = { left = nil, right = nil, left_buf = nil, right_buf = nil }

local function ensure_buf(side)
    local key = side .. "_buf"
    if placeholders[key] and vim.api.nvim_buf_is_valid(placeholders[key]) then
        return placeholders[key]
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { " " })
    placeholders[key] = buf
    return buf
end

local function close_placeholder(side)
    local win = placeholders[side]
    if win and vim.api.nvim_win_is_valid(win) then
        pcall(vim.api.nvim_win_close, win, true)
    end
    placeholders[side] = nil
end

local function clear_all_placeholders()
    close_placeholder("left")
    close_placeholder("right")
    local lb = placeholders.left_buf
    if lb and vim.api.nvim_buf_is_valid(lb) then
        pcall(vim.api.nvim_buf_delete, lb, { force = true })
    end
    placeholders.left_buf = nil
    local rb = placeholders.right_buf
    if rb and vim.api.nvim_buf_is_valid(rb) then
        pcall(vim.api.nvim_buf_delete, rb, { force = true })
    end
    placeholders.right_buf = nil
end

local function num(x)
    if type(x) == "number" then
        return x
    end
    return 0
end

local function compute_edges(mini_windows)
    local leftmost, rightmost = nil, nil
    for _, w in ipairs(mini_windows) do
        local cfg = vim.api.nvim_win_get_config(w.win_id)
        local col = num(cfg.col)
        local row = num(cfg.row)
        local width = num(cfg.width)
        local height = num(cfg.height)
        if not leftmost or col < leftmost.col then
            leftmost =
                { win_id = w.win_id, col = col, row = row, width = width, height = height, relative = cfg.relative }
        end
        local right_edge = col + width + BORDER_PAD
        if not rightmost or right_edge > rightmost.edge then
            rightmost = {
                win_id = w.win_id,
                col = col,
                row = row,
                width = width,
                height = height,
                edge = right_edge,
                relative = cfg.relative,
            }
        end
    end
    return leftmost, rightmost
end

local function open_or_update_placeholder(side, pos, dims)
    local buf = ensure_buf(side)
    local win = placeholders[side]
    local cfg = {
        relative = dims.relative or "editor",
        row = pos.row,
        col = pos.col,
        width = dims.width,
        height = dims.height,
        style = "minimal",
        border = "rounded",
    }
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, cfg)
    else
        win = vim.api.nvim_open_win(buf, false, cfg)
        placeholders[side] = win
    end
    vim.wo[win].winblend = 0
    apply_window_style(win)
end

local function update_placeholders(parent_exists, right_exists)
    local MiniFiles = get_mini_files()
    if not MiniFiles then
        return
    end
    local state = MiniFiles.get_explorer_state()
    if not state or not state.windows or #state.windows == 0 then
        clear_all_placeholders()
        return
    end
    local leftmost, rightmost = compute_edges(state.windows)
    local relative = (leftmost and leftmost.relative) or "editor"
    local height = math.min(MAX_HEIGHT, vim.o.lines - UI_MIN_SIZE)
    local cfg = get_config_snapshot()
    local left_width = cfg.width_nofocus
    local right_width = (cfg.preview and cfg.width_preview) or cfg.width_nofocus
    if not parent_exists and leftmost then
        local col = math.max(0, num(leftmost.col) - (left_width + BORDER_PAD))
        open_or_update_placeholder(
            "left",
            { row = leftmost.row, col = col },
            { width = left_width, height = height, relative = relative }
        )
    else
        close_placeholder("left")
    end
    if not right_exists and rightmost then
        local col = num(rightmost.col) + num(rightmost.width) + BORDER_PAD
        open_or_update_placeholder(
            "right",
            { row = rightmost.row, col = col },
            { width = right_width, height = height, relative = relative }
        )
    else
        close_placeholder("right")
    end
end

local enforcing_guard = false
local function maintain_three_column_view()
    if enforcing_guard then
        return
    end
    local MiniFiles = get_mini_files()
    if not MiniFiles then
        return
    end
    local state = MiniFiles.get_explorer_state()
    if not state or not state.branch or #state.branch == 0 then
        return
    end
    local branch = state.branch
    local depth_focus = state.depth_focus or #branch
    local focus_path = branch[depth_focus]
    if not focus_path then
        return
    end
    local parent_path = get_parent_path(state, focus_path, depth_focus)
    local right_path = get_right_path(state, depth_focus)
    local new_branch = {}
    if parent_path then
        table.insert(new_branch, parent_path)
    end
    table.insert(new_branch, focus_path)
    if right_path then
        table.insert(new_branch, right_path)
    end
    if not branches_equal(new_branch, branch) then
        enforcing_guard = true
        pcall(MiniFiles.set_branch, new_branch, { depth_focus = parent_path and 2 or 1 })
        enforcing_guard = false
    end
    update_placeholders(parent_path ~= nil, right_path ~= nil)
end

local group = vim.api.nvim_create_augroup("MiniFilesRangerView", { clear = true })

vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MiniFilesWindowOpen",
    callback = function(args)
        local win_id = args.data.win_id
        if win_id then
            vim.wo[win_id].winblend = 0
            apply_window_style(win_id)
        end
        maintain_three_column_view()
    end,
})

vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MiniFilesWindowUpdate",
    callback = function(args)
        if args.data and args.data.win_id then
            apply_window_style(args.data.win_id)
        end
        vim.schedule(maintain_three_column_view)
    end,
})

vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MiniFilesExplorerClose",
    callback = function()
        clear_all_placeholders()
    end,
})

return {
    "echasnovski/mini.files",
    lazy = true,
    opts = {
        options = { use_as_default_explorer = true },
        windows = { max_number = 3, preview = true },
        mappings = {
            -- testing with the swapped go_in
            go_in = "L",
            go_in_plus = "l",
            go_out = "H",
            go_out_plus = "h",
        },
    },
    keys = {
        { "<leader>e", "", desc = "+file explorer", mode = { "n", "v" } },
        {
            "<leader>ee",
            function()
                local MiniFiles = require("mini.files")
                local current_file = vim.api.nvim_buf_get_name(0)
                MiniFiles.open(current_file, false)
                MiniFiles.reveal_cwd()
            end,
            desc = "Open mini.files (Directory of Current File)",
        },
        {
            "<leader>ec",
            function()
                require("mini.files").open(vim.uv.cwd(), true)
            end,
            desc = "Open mini.files (CWD, Save State)",
        },
        {
            "<leader>eC",
            function()
                require("mini.files").open(vim.uv.cwd(), false)
            end,
            desc = "Open mini.files (CWD, Without State)",
        },
    },
}
