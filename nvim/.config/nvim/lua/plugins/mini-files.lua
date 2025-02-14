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
        {
            "<leader>ee",
            function()
                local MiniFiles = require("mini.files")
                local current_file = vim.api.nvim_buf_get_name(0)
                local _ = MiniFiles.close() or MiniFiles.open(current_file, false)
                MiniFiles.reveal_cwd()
            end,
            desc = "Open mini.files (Directory of Current File)",
        },
        {
            "<leader>ec",
            function()
                local MiniFiles = require("mini.files")
                local current_file = vim.api.nvim_buf_get_name(0)
                local _ = MiniFiles.close() or MiniFiles.open(current_file, false)
                MiniFiles.reveal_cwd()
            end,
        },
    },

    config = function(_, opts)
        require("mini.files").setup(opts)

        -- Mini files layout for a Ranger/Yazi style
        local function set_window_style(win_id)
            local config = vim.api.nvim_win_get_config(win_id)
            config.border = "rounded"
            config.title_pos = "left"
            -- Using a dynamic height: if the available height is small, change accordingly.
            local max_height = 15
            local available_height = vim.o.lines - 10 -- account for cmd line and other UI elements
            config.height = math.min(max_height, available_height)
            -- Ensure title padding: add a space at both ends.
            if #config.title == 0 or config.title[1][1] ~= " " then
                table.insert(config.title, 1, { " ", "NormalFloat" })
            end
            if config.title[#config.title][1] ~= " " then
                table.insert(config.title, { " ", "NormalFloat" })
            end
            vim.api.nvim_win_set_config(win_id, config)
        end

        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesWindowOpen",
            callback = function(args)
                local win_id = args.data.win_id
                vim.wo[win_id].winblend = 0 -- use opaque window
                set_window_style(win_id)
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "MiniFilesWindowUpdate",
            callback = function(args)
                set_window_style(args.data.win_id)
            end,
        })
    end,
}
