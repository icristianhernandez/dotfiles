-- Editor enhancements and navigation plugins
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

-- Auto-session configuration
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,"

return {
    -- echasnovski/mini.files: Lightweight file explorer with custom layout
    {
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
    },

    -- rmagatti/auto-session: Automatic session save and restore with git branch awareness
    {
        "rmagatti/auto-session",
        lazy = false,

        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            bypass_save_filetypes = { "alpha", "dashboard" },
            git_use_branch_name = true,
            git_auto_restore_on_branch_change = true,
            auto_restore_last_session = vim.fn.getcwd() == vim.fn.expand("~")
                and vim.fn.argc() == 0
                and (#vim.api.nvim_list_uis() > 0),
            cwd_change_handling = true,
            continue_restore_on_error = true,
        },
        keys = {
            {
                "<leader>fs",
                "<cmd>AutoSession search<CR>",
                { noremap = true, desc = "Search session" },
            },
            {
                "<leader>fS",
                "<cmd>AutoSession deletePicker<CR>",
                { noremap = true, desc = "Delete sessions" },
            },
        },
    },

    -- mrjones2014/smart-splits.nvim: Intelligent split resizing
    {
        "mrjones2014/smart-splits.nvim",
        lazy = true,

        keys = {
            {
                "<Up>",
                "<cmd>lua require('smart-splits').resize_up()<CR>",
                { noremap = true, silent = true, desc = "Resize split up" },
            },
            {
                "<Down>",
                "<cmd>lua require('smart-splits').resize_down()<CR>",
                { noremap = true, silent = true, desc = "Resize split down" },
            },
            {
                "<Left>",
                "<cmd>lua require('smart-splits').resize_left()<CR>",
                { noremap = true, silent = true, desc = "Resize split left" },
            },
            {
                "<Right>",
                "<cmd>lua require('smart-splits').resize_right()<CR>",
                { noremap = true, silent = true, desc = "Resize split right" },
            },
        },

        opts = {},
    },

    -- NMAC427/guess-indent.nvim: Automatically detect and set indentation
    {
        "NMAC427/guess-indent.nvim",
        lazy = false,
        opts = {},
    },

    -- nacro90/numb.nvim: Peek at line numbers when using goto commands
    {
        "nacro90/numb.nvim",
        lazy = true,
        keys = {
            { ":" },
        },
        opts = {},
    },

    -- stevearc/quicker.nvim: Enhanced quickfix window with context-aware features
    {
        "stevearc/quicker.nvim",

        ---@module "quicker"
        ---@type quicker.SetupOptions
        opts = {
            keys = {
                {
                    ">",
                    function()
                        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                    end,
                    desc = "Expand quickfix context",
                },
                {
                    "<",
                    function()
                        require("quicker").collapse()
                    end,
                    desc = "Collapse quickfix context",
                },
            },
        },
    },

    -- nvimdev/hlsearch.nvim: Automatically remove search highlighting after movement
    {
        "nvimdev/hlsearch.nvim",
        opts = {},
    },
}
