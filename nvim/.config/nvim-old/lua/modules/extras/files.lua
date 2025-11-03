local M = {}

function M.setup()
    local aug = vim.api.nvim_create_augroup("MiniFilesWindowStyle", { clear = true })

    local function set_window_style(win_id)
        local max_height = 15
        local ui_min_size = 10
        local available_height = vim.o.lines - ui_min_size

        local config = vim.api.nvim_win_get_config(win_id)
        config.border = "rounded"
        config.title_pos = "left"
        config.height = math.min(max_height, available_height)

        vim.api.nvim_win_set_config(win_id, config)
    end

    vim.api.nvim_create_autocmd("User", {
        group = aug,
        pattern = "MiniFilesWindowOpen",
        callback = function(args)
            local win_id = args.data and args.data.win_id
            if not win_id then
                return
            end
            vim.wo[win_id].winblend = 0
            set_window_style(win_id)
        end,
    })

    vim.api.nvim_create_autocmd("User", {
        group = aug,
        pattern = "MiniFilesWindowUpdate",
        callback = function(args)
            local win_id = args.data and args.data.win_id
            if not win_id then
                return
            end
            set_window_style(win_id)
        end,
    })
end

return M
