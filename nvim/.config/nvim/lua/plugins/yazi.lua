---@type LazySpec
return {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>ee",
            "<cmd>Yazi<cr>",
            desc = "Open yazi at the current file",
        },
        {
            "<leader>er",
            "<cmd>Yazi toggle<cr>",
            desc = "Resume the last yazi session",
        },
        -- {
        --     "<leader>ec",
        --     "<cmd>Yazi cwd<cr>",
        --     desc = "Open the file manager in nvim's working directory"
        -- }
    },

    config = function()
        require("yazi").setup({
            -- netrw replacement
            open_for_directories = false,

            -- enable these if you are using the latest version of yazi
            use_ya_for_events_reading = true,
            use_yazi_client_id_flag = true,

            floating_window_scaling_factor = 0.85,
            yazi_floating_window_border = "single",

            keymaps = {
                show_help = "<f1>",
            },
        })
    end,
}
