return {
    -- nacro90/numb.nvim: show line number hints while typing commands
    {
        "nacro90/numb.nvim",
        lazy = true,
        keys = { { ":" } },
        opts = {},
    },

    -- echasnovski/mini.files: lightweight file explorer ( with 3-column helpers as custom )
    {
        "echasnovski/mini.files",
        lazy = true,
        opts = {
            options = { use_as_default_explorer = true },
            windows = { max_number = 3, preview = true },
            mappings = {
                go_in = "L",
                go_in_plus = "l",
                go_out = "H",
                go_out_plus = "h",
            },
        },
        config = function(_, opts)
            require("mini.files").setup(opts)
            require("modules.extras.files").setup()
        end,
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

    -- ThePrimeagen/harpoon: quick file bookmarking and navigation
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        opts = {
            menu = { width = vim.api.nvim_win_get_width(0) - 4 },
            settings = { save_on_toggle = true },
        },
        keys = function()
            local keys = {
                {
                    "<leader>H",
                    function()
                        require("harpoon"):list():add()
                    end,
                    desc = "Harpoon Current File",
                },
                {
                    "<leader>h",
                    function()
                        local harpoon = require("harpoon")
                        harpoon.ui:toggle_quick_menu(harpoon:list())
                    end,
                    desc = "Harpoon Quick Menu",
                },
            }
            for i = 1, 9 do
                table.insert(keys, {
                    "<leader>" .. i,
                    function()
                        require("harpoon"):list():select(i)
                    end,
                    desc = "Harpoon to File " .. i,
                })
            end
            return keys
        end,
    },

    -- stevearc/quicker.nvim: enhance quickfix/diagnostic navigation with context expansion
    {
        "stevearc/quicker.nvim",

        ---@module "quicker"
        ---@type quicker.SetupOptions
        opts = {
            keys = {
                {
                    ">",
                    function()
                        require("quicker").expand({ before = 1, after = 2, add_to_existing = true })
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

    -- mrjones2014/smart-splits.nvim: smart split resizing and movement
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

    -- NMAC427/guess-indent.nvim: detect indentation settings per-file automatically
    { "NMAC427/guess-indent.nvim", lazy = false, opts = {} },

    -- rmagatti/auto-session: automatic session save/restore with branch-aware handling
    {
        "rmagatti/auto-session",
        lazy = false,
        init = function()
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,"
        end,

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
            { "<leader>fs", "<cmd>AutoSession search<CR>", { noremap = true, desc = "Search session" } },
            { "<leader>fS", "<cmd>AutoSession deletePicker<CR>", { noremap = true, desc = "Delete sessions" } },
        },
    },
}
