-- Mini files layout for a Ranger/Yazi style
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
    pattern = "MiniFilesWindowOpen",
    callback = function(args)
        local win_id = args.data.win_id
        vim.wo[win_id].winblend = 0
        set_window_style(win_id)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesWindowUpdate",
    callback = function(args)
        set_window_style(args.data.win_id)
    end,
})

return {
    "echasnovski/mini.files",
    lazy = true,

    opts = {
        options = {
            use_as_default_explorer = true,
        },

        mappings = {
            -- testing with the swaped go_in
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
