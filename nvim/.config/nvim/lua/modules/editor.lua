return {
    {
        "rmagatti/auto-session",
        lazy = false,
        init = function()
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,"
        end,

        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
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
    {
        "echasnovski/mini.files",
        lazy = true,
        opts = {
            options = { use_as_default_explorer = true },
            windows = {
                max_number = 3,
                preview = true,
                width_focus = 35,
                width_preview = 35,
            },
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
    {
        "folke/snacks.nvim",
        event = "VeryLazy",
        ---@type snacks.Config
        opts = {
            terminal = {
                win = { style = "float" },
            },

            picker = {
                layouts = { vertical = { layout = { min_height = 18 } } },
                win = {
                    input = {
                        keys = {
                            ["<Esc>"] = { "close", mode = { "n", "i" } },
                            ["<C-h>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
                            ["<C-bs>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
                            ["<Up>"] = { "select_and_prev", mode = { "i", "n" } },
                            ["<Down>"] = { "select_and_next", mode = { "i", "n" } },
                            ["<Tab>"] = { "list_down", mode = { "i", "n" } },
                            ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                        },
                    },
                },
                sources = {
                    files = { hidden = true },
                    search = { hidden = true },
                    grep = { hidden = true },
                },
            },
        },

        keys = {
            {
                "<c-space>",
                function()
                    Snacks.terminal()
                end,
                desc = "Terminal (cwd)",
                mode = { "n", "t", "i" },
            },
            {
                "<C-n>",
                function()
                    Snacks.scratch()
                end,
                desc = "Toggle Scratch Buffer",
            },
            {
                "<C-n>",
                function()
                    Snacks.scratch()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
                end,
                mode = "i",
                desc = "Toggle Scratch Buffer",
            },
            {
                "<leader>sn",
                function()
                    Snacks.scratch.select()
                end,
                desc = "Select Scratch Buffer",
            },
            {
                "<leader>/",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep (Root Dir)",
            },
            {
                "<leader>:",
                function()
                    Snacks.picker.command_history()
                end,
                desc = "Command History",
            },
            {
                "<leader>n",
                function()
                    Snacks.picker.notifications()
                end,
                desc = "Notification History",
            },
            -- find
            {
                "<leader>ff",
                function()
                    Snacks.picker.files()
                end,
                desc = "Find Files (Root Dir)",
            },
            {
                "<leader>fF",
                function()
                    Snacks.picker.files({ root = false })
                end,
                desc = "Find Files (cwd)",
            },
            {
                "<leader>fr",
                function()
                    Snacks.picker.recent()
                end,
                desc = "Recent",
            },

            -- git
            {
                "<leader>gd",
                function()
                    Snacks.picker.git_diff()
                end,
                desc = "Git Diff (hunks)",
            },
            {
                "<leader>gs",
                function()
                    Snacks.picker.git_status()
                end,
                desc = "Git Status",
            },
            {
                "<leader>gS",
                function()
                    Snacks.picker.git_stash()
                end,
                desc = "Git Stash",
            },
            -- search
            {
                "<leader>sC",
                function()
                    Snacks.picker.commands()
                end,
                desc = "Commands",
            },
            {
                "<leader>sd",
                function()
                    Snacks.picker.diagnostics()
                end,
                desc = "Diagnostics",
            },
            {
                "<leader>sD",
                function()
                    Snacks.picker.diagnostics_buffer()
                end,
                desc = "Buffer Diagnostics",
            },
            {
                "<leader>sk",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Keymaps",
            },
            {
                "<leader>sR",
                function()
                    Snacks.picker.resume()
                end,
                desc = "Resume",
            },
            {
                "<leader>su",
                function()
                    Snacks.picker.undo()
                end,
                desc = "Undotree",
            },
            -- ui
            {
                "<leader>uC",
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = "Colorschemes",
            },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix",
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },

    {
        -- ThePrimeagen/harpoon: quick file bookmarking and navigation
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },

        opts = {
            menu = { width = vim.api.nvim_win_get_width(0) - 4 },
            settings = { save_on_toggle = true },
        },

        keys = function()
            local harpoon = require("harpoon")

            local keys = {
                {
                    "<leader>H",
                    function()
                        harpoon:list():add()
                    end,
                    desc = "Harpoon Current File",
                },
                {
                    "<leader>h",
                    function()
                        harpoon.ui:toggle_quick_menu(harpoon:list())
                    end,
                    desc = "Harpoon Quick Menu",
                },
            }
            for i = 1, 9 do
                table.insert(keys, {
                    "<leader>" .. i,
                    function()
                        harpoon:list():select(i)
                    end,
                    desc = "Harpoon to File " .. i,
                })
            end
            return keys
        end,

        config = function(_, opts)
            require("harpoon"):setup(opts)
        end,
    },

    {
        -- stevearc/quicker.nvim: enhance quickfix/diagnostic navigation with context expansion
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
}
