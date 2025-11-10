return {
    {
        "rmagatti/auto-session",
        lazy = false,
        priority = 999,
        init = function()
            vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,terminal,localoptions"
        end,

        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            git_use_branch_name = true,
            git_auto_restore_on_branch_change = true,
            cwd_change_handling = true,
            auto_restore_last_session = vim.fn.getcwd() == vim.fn.expand("~")
                and vim.fn.argc() == 0
                and (#vim.api.nvim_list_uis() > 0),
            continue_restore_on_error = true,
        },

        keys = {
            { "<leader>ss", "<cmd>AutoSession search<CR>", { noremap = true, desc = "Search session" } },
            { "<leader>sS", "<cmd>AutoSession deletePicker<CR>", { noremap = true, desc = "Delete sessions" } },
        },
    },

    {
        "echasnovski/mini.files",
        dependencies = {
            "nvim-mini/mini.icons",
            "folke/snacks.nvim",
        },
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

            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesActionRename",
                callback = function(event)
                    Snacks.rename.on_rename_file(event.data.from, event.data.to)
                end,
            })
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
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "xzbdmw/colorful-menu.nvim",
        },
        opts_extend = { "sources.default" },

        -- use a release tag to download pre-built binaries
        version = "1.*",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "none",
                ["<Tab>"] = {
                    -- function(cmp)
                    --     if #cmp.get_items() == 1 then
                    --         return cmp.select_and_accept()
                    --     end
                    -- end,
                    "select_next",
                    "snippet_forward",
                    "fallback",
                },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-d>"] = { "show", "hide", "fallback" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },

            signature = {
                enabled = true,
                trigger = {
                    show_on_keyword = true,
                    show_on_insert = true,
                },
            },

            completion = {
                menu = {
                    auto_show_delay_ms = 30,
                    max_height = 8,
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
                documentation = { auto_show = true, auto_show_delay_ms = 10 },

                list = { selection = { preselect = false, auto_insert = false } },

                keyword = { range = "full" },
                ghost_text = { enabled = true },

                trigger = {
                    show_on_blocked_trigger_characters = {},
                    show_on_keyword = true,
                    show_on_insert = true,
                    show_on_backspace = true,
                    show_on_backspace_after_insert_enter = true,
                    show_on_backspace_in_keyword = true,
                    show_on_backspace_after_accept = true,
                    show_on_trigger_character = true,
                    show_on_insert_on_trigger_character = true,
                    show_on_accept_on_trigger_character = true,
                },
            },

            sources = {
                providers = {
                    lsp = {
                        name = "LSP",
                        module = "blink.cmp.sources.lsp",
                        transform_items = function(_, items)
                            return vim.tbl_filter(function(item)
                                return item.kind ~= require("blink.cmp.types").CompletionItemKind.Keyword
                            end, items)
                        end,

                        override = {
                            get_trigger_characters = function(self)
                                local trigger_characters = self:get_trigger_characters()
                                -- vim.list_extend(trigger_characters, { "\n", "\t", " ", "-" })
                                vim.list_extend(trigger_characters, { "\n", "\t", " ", "-" })
                                return trigger_characters
                            end,
                        },
                    },
                },
            },

            cmdline = {
                keymap = { preset = "inherit" },
                completion = {
                    list = {
                        selection = {
                            preselect = false,
                            auto_insert = true,
                        },
                    },
                    menu = { auto_show = true },
                },
            },
        },

        config = function(_, opts)
            -- make sure backspace in select mode works as expected
            vim.keymap.set("s", "<BS>", "<C-O>s")

            require("blink.cmp").setup(opts)
        end,
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
            spec = {
                {
                    mode = { "n", "x" },
                    { "<leader><tab>", group = "tabs" },
                    { "<leader>d", group = "debug" },
                    { "<leader>f", group = "file/find" },
                    { "<leader>g", group = "git" },
                    { "<leader>gh", group = "hunks" },
                    { "<leader>q", group = "quit/session" },
                    { "<leader>s", group = "search" },
                    { "<leader>u", group = "ui" },
                    { "<leader>x", group = "diagnostics/quickfix" },
                    { "<leader>a", group = "ai" },
                    { "<leader>c", group = "code" },
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                    { "z", group = "fold" },
                    {
                        "<leader>w",
                        group = "windows",
                        proxy = "<c-w>",
                        expand = function()
                            return require("which-key.extras").expand.win()
                        end,
                    },
                },
            },
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
        "cbochs/grapple.nvim",
        dependencies = {
            { "nvim-mini/mini.icons", lazy = true },
        },
        opts = {
            scope = "git_branch",
        },
        keys = function()
            local k = {
                {
                    "<leader>H",
                    function()
                        require("grapple").toggle()
                    end,
                    desc = "Tag a file",
                },
                {
                    "<leader>h",
                    function()
                        require("grapple").toggle_tags()
                    end,
                    desc = "Toggle Grapple tags window",
                },
            }
            -- select tag index
            for i = 1, 9 do
                table.insert(k, {
                    "<leader>" .. i,
                    function()
                        require("grapple").select({ index = i })
                    end,
                    desc = "Select grapple tag " .. i,
                })
            end
            return k
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
    {
        -- nacro90/numb.nvim: show line number hints while typing commands
        "nacro90/numb.nvim",
        lazy = true,
        keys = { { ":" } },
        opts = {},
    },
    {
        -- folke/flash.nvim: enhanced motion and search with labels and treesitter integration
        "folke/flash.nvim",
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            { "f", mode = { "n", "x", "o" }, desc = "Flash" },
            { "F", mode = { "n", "x", "o" }, desc = "Flash" },
            { "t", mode = { "n", "x", "o" }, desc = "Flash" },
            { "T", mode = { "n", "x", "o" }, desc = "Flash" },
            { ";", mode = { "n", "x", "o" }, desc = "Flash Next" },
        },

        opts = {
            labels = "asdfgqwertzxcvb",
            modes = {
                char = {
                    char_actions = function()
                        return {
                            [";"] = "next",
                            ["f"] = "right",
                            ["F"] = "left",
                        }
                    end,
                    enabled = true,
                    keys = { "f", "F", "t", "T", ";" },
                    jump_labels = false,
                    multi_line = true,
                },
            },
            prompt = {
                win_config = { border = "none" },
            },
            search = {
                wrap = true,
            },
            label = {
                rainbow = {
                    enabled = true,
                    shade = 1,
                },
            },
        },
    },
    {
        -- m4xshen/hardtime.nvim: enforce efficient editing habits by restricting keys
        "m4xshen/hardtime.nvim",
        lazy = false,
        -- MunifTanjim/nui.nvim: UI component library used by plugins
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            disable_mouse = false,
            restricted_keys = {
                ["k"] = false,
                ["j"] = false,
            },
            disabled_keys = {
                ["<Up>"] = false,
                ["<Down>"] = false,
                ["<Left>"] = false,
                ["<Right>"] = false,
            },
        },
    },
    {
        -- mrjones2014/smart-splits.nvim: smart split resizing and movement
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
    {
        -- NMAC427/guess-indent.nvim: detect indentation settings per-file automatically
        "NMAC427/guess-indent.nvim",
        lazy = false,
        opts = {},
    },
}
