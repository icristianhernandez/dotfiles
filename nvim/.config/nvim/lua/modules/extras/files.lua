local M = {}

function M.setup()
    local group = vim.api.nvim_create_augroup("MiniFilesExtras", { clear = true })

    vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "MiniFilesWindowUpdate",

        callback = function(args)
            local win_id = args and args.data and args.data.win_id
            if not win_id then
                return
            end
            local h = math.max(math.floor(vim.o.lines * 0.20), 14)
            local cfg = vim.api.nvim_win_get_config(win_id)
            cfg.height = h
            vim.api.nvim_win_set_config(win_id, cfg)
        end,
    })
end

return M
