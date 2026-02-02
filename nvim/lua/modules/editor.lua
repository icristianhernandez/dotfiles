return {
    {
        -- rmagatti/auto-session: automatic session save/restore
        "rmagatti/auto-session",
        lazy = false,
        priority = 998,
        init = function()
            vim.o.sessionoptions = "blank,buffers,folds,curdir,help,tabpages,terminal,localoptions"
            -- vim.o.sessionoptions = "blank,curdir"
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
        -- echasnovski/mini.files: lightweight file explorer
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
                width_preview = 60,
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

            -- BUG: the confirmation floating windows of snack closes mini.files.
            -- Potential explanation:
            -- mini.files starts a timer every time MiniFiles.open() runs (see H.explorer_track_lost_focus in the upstream mini/files.lua). Once per second it checks the currently focused buffer’s filetype; if it isn’t minifiles/minifiles-help, it calls MiniFiles.close() proactively.
            -- Snacks.rename.rename_file() (triggered by your grN mapping in editor.lua) collects the new filename via vim.ui.input, which Snacks overrides with its own floating “snacks_input” window. Typing in that prompt steals focus from the explorer for longer than a second, so the timer decides the explorer was “abandoned” and closes it.
            vim.api.nvim_create_autocmd("User", {
                pattern = "MiniFilesActionRename",
                callback = function(event)
                    Snacks.rename.on_rename_file(event.data.from, event.data.to)
                end,
            })

            local MiniFiles = require("mini.files")
            local orig_close = MiniFiles.close

            -- Workaround fix: override MiniFiles.close to ignore calls when Snacks floating windows are open.
            ---@diagnostic disable-next-line: duplicate-set-field
            MiniFiles.close = function(...)
                local ft = vim.bo.filetype or ""

                local function is_ignored_ft(ft_to_check)
                    return ft_to_check == "TelescopePrompt" or ft_to_check == "noice" or ft_to_check:match("^snacks")
                end

                local function current_win_is_floating()
                    local ok, cfg = pcall(vim.api.nvim_win_get_config, 0)
                    return ok and cfg and cfg.relative and cfg.relative ~= ""
                end

                if is_ignored_ft(ft) and current_win_is_floating() then
                    return false
                end

                return orig_close(...)
            end
        end,
        keys = {
            { "<leader>e", "", desc = "+file explorer", mode = { "n", "x" } },
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
                    require("mini.files").open(vim.fn.getcwd(), true)
                end,
                desc = "Open mini.files (CWD, Save State)",
            },
            {
                "<leader>eC",
                function()
                    require("mini.files").open(vim.fn.getcwd(), false)
                end,
                desc = "Open mini.files (CWD, Without State)",
            },
        },
    },

    {
        "nvim-mini/mini.cmdline",
        version = false,
        opts = {
            autopeek = {
                n_context = 3,
            },
        },
    },

    {
        -- blink.cmp: next-generation completion framework
        "saghen/blink.cmp",
        -- use a release tag to download pre-built binaries
        version = "1.*",
        opts_extend = { "sources.default", "sources.providers" },

        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                event = "VeryLazy",
                dependencies = { "rafamadriz/friendly-snippets" },
                config = function()
                    require("luasnip").setup({
                        loaders_store_source = false,
                        update_events = { "InsertLeave", "TextChangedI" },
                        history = true,
                        delete_check_events = "TextChanged",
                    })
                    require("luasnip.loaders.from_vscode").lazy_load()
                    require("luasnip.loaders.from_vscode").lazy_load({
                        paths = { vim.fn.stdpath("config") .. "/snippets" },
                    })
                end,
            },
            {
                -- onsails/lspkind.nvim: VS Code-like pictograms for LSP kinds
                "onsails/lspkind.nvim",
                lazy = false,
                opts = {
                    preset = "default",
                },
                config = function(_, opts)
                    require("lspkind").init(opts)
                end,
            },
        },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            snippets = { preset = "luasnip" },
            keymap = {
                preset = "none",
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-e>"] = { "show", "hide", "fallback" },
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
                    -- testing that:
                    auto_show_delay_ms = 0,
                    max_height = 8,
                    draw = {
                        columns = { { "label", "label_description", gap = 1 }, { "kind_icon", gap = 1, "kind" } },
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    return require("lspkind").symbolic(ctx.kind, { mode = "symbol" }) .. ctx.icon_gap
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
                    show_on_backspace = true,
                    show_on_insert = true,
                    show_on_trigger_character = true,
                    show_on_accept_on_trigger_character = true,
                    show_on_insert_on_trigger_character = true,
                    -- show_on_keyword = true,
                    -- show_on_insert = true,
                    -- show_on_backspace = true,
                    -- show_on_backspace_after_insert_enter = true,
                    -- show_on_backspace_in_keyword = true,
                    -- show_on_backspace_after_accept = true,
                },
            },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },

                providers = {
                    lsp = {
                        name = "LSP",
                        module = "blink.cmp.sources.lsp",
                        transform_items = function(_, items)
                            local kinds = require("blink.cmp.types").CompletionItemKind

                            return vim.tbl_filter(function(item)
                                return item.kind ~= kinds.Snippet
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
                enabled = false,
            },
        },

        config = function(_, opts)
            -- make sure backspace in select mode works as expected
            vim.keymap.set("s", "<BS>", "<C-O>s")

            require("blink.cmp").setup(opts)
        end,
    },

    {
        -- Snacks: a collection of small (not so small) plugins related to nvim
        "folke/snacks.nvim",
        priority = 999,
        lazy = false,

        ---@type snacks.Config
        opts = {
            words = {
                enabled = true,
                debounce = 100,
                modes = { "n", "c" },
            },

            bigfile = {
                enabled = true,
            },

            terminal = {
                win = {
                    style = "float",
                },
            },

            scratch = {
                -- win = { border = false, minimal = true, footer_keys = false, wo = { winbar = "" } },
                win = {
                    footer_keys = false,
                    on_win = function(self)
                        self:set_title("")
                    end,
                },
                root = vim.fn.expand("~/dotfiles/notes"),
                ft = function()
                    return "markdown"
                end,
            },

            picker = {
                -- styles: "default", "dropdown", "ivy", "ivy_split", "left", "right", "select", "sidebar", "vertical", "vscode", "telescope", "top", "bottom"
                layout = "sidebar",
                ui_select = true,

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
                    git_diff = {
                        win = {
                            input = {
                                keys = {
                                    ["<Tab>"] = { "list_down", mode = { "i", "n" } },
                                    ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                                    ["<C-s>"] = { "git_stage", mode = { "n", "i" } },
                                    ["<C-r>"] = { "git_restore", mode = { "n", "i" }, nowait = true },
                                },
                            },
                        },
                    },

                    git_status = {
                        win = {
                            input = {
                                keys = {
                                    ["<Tab>"] = { "list_down", mode = { "i", "n" } },
                                    ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                                    ["<C-s>"] = { "git_stage", mode = { "n", "i" } },
                                    ["<C-r>"] = { "git_restore", mode = { "n", "i" }, nowait = true },
                                },
                            },
                        },
                    },
                },
            },
        },

        keys = {
            -- lazygit
            {
                "<leader>gg",
                function()
                    Snacks.lazygit.open()
                end,
                desc = "Open Lazygit",
            },
            -- terminal: toggle last terminal on <c-space>
            {
                "<c-space>",
                function()
                    require("modules.extras.snacks_term").toggle_last()
                end,
                desc = "Toggle last snacks terminal",
                mode = { "n", "t", "i" },
            },
            -- snacks terminal picker / toggle-last mappings
            {
                "<leader>tl",
                function()
                    require("modules.extras.snacks_term").pick()
                end,
                desc = "Select snacks terminal",
            },
            {
                "<leader>tn",
                function()
                    require("modules.extras.snacks_term").open(nil, { interactive = true, new = true })
                end,
                desc = "New snacks terminal",
            },
            {
                "<C-n>",
                function()
                    Snacks.scratch()
                end,
                desc = "Toggle Scratch Buffer",
            },

            -- scratch pad
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

            -- find
            -- {
            --     "<leader>ff",
            --     function()
            --         Snacks.picker.files()
            --     end,
            --     desc = "Find Files (Root Dir)",
            -- },
            {
                "<leader>ff",
                function()
                    Snacks.picker.smart()
                end,
                desc = "Smart Find Files",
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
                desc = "Recent opened files",
            },

            -- git
            {
                "<leader>gx",
                function()
                    Snacks.gitbrowse()
                end,
                desc = "Git Browse",
                mode = { "n", "x" },
            },
            {
                "<leader>gb",
                function()
                    Snacks.picker.git_branches()
                end,
                desc = "Git Branches",
            },
            {
                "<leader>gl",
                function()
                    Snacks.picker.git_log()
                end,
                desc = "Git Log",
            },
            {
                "<leader>gL",
                function()
                    Snacks.picker.git_log_line()
                end,
                desc = "Git Log Line",
            },
            {
                "<leader>gf",
                function()
                    Snacks.picker.git_log_file()
                end,
                desc = "Git Log File",
            },
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
                "<leader>/",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep (Root Dir)",
            },
            {
                "<leader>sw",
                function()
                    Snacks.picker.grep_word()
                end,
                desc = "Visual selection or word",
                mode = { "n", "x" },
            },
            {
                "<leader>sg",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep",
            },
            {
                "<leader>sc",
                function()
                    Snacks.picker.commands()
                end,
                desc = "Commands",
            },
            {
                "<leader>:",
                function()
                    Snacks.picker.command_history()
                end,
                desc = "Command History",
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
                "<leader>sr",
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
                "<leader>uc",
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = "Colorschemes",
            },
            {
                "<leader>uq",
                function()
                    Snacks.notifier.hide()
                end,
                desc = "Dismiss All Notifications",
            },
            -- {
            --     "<leader>n",
            --     function()
            --         Snacks.picker.notifications()
            --     end,
            --     desc = "Notification History",
            -- },
            {
                "<leader>n",
                function()
                    Snacks.notifier.show_history()
                end,
                desc = "Notification History",
            },

            -- ui toggles
            {
                "<leader>us",
                function()
                    Snacks.toggle.option("spell", { name = "Spelling" }):toggle()
                end,
                desc = "Toggle Spelling",
            },
            {
                "<leader>uw",
                function()
                    Snacks.toggle.option("wrap", { name = "Wrap" }):toggle()
                end,
                desc = "Toggle Wrap",
            },
            {
                "<leader>ul",
                function()
                    Snacks.toggle
                        .option(
                            "conceallevel",
                            { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }
                        )
                        :toggle()
                end,
                desc = "Toggle Conceal Level",
            },
            {
                "<leader>ub",
                function()
                    Snacks.toggle
                        .option("background", { off = "light", on = "dark", name = "Dark Background" })
                        :toggle()
                end,
                desc = "Toggle Dark Background",
            },
            {
                "<leader>uh",
                function()
                    Snacks.toggle.inlay_hints():toggle()
                end,
                desc = "Toggle Inlay Hints",
            },
            -- ui toggle diagnostics, scroll, treesitter
            {
                "<leader>ud",
                function()
                    Snacks.toggle.diagnostics():toggle()
                end,
                desc = "Toggle Diagnostics",
            },
            {
                "<leader>ut",
                function()
                    Snacks.toggle.treesitter():toggle()
                end,
                desc = "Toggle Treesitter Highlights",
            },
            {
                "<leader>us",
                function()
                    Snacks.toggle.scroll():toggle()
                end,
                desc = "Toggle Scrollbar Animation",
            },

            -- actions
            {
                "grN",
                function()
                    Snacks.rename.rename_file()
                end,
                desc = "Rename File",
            },
            {
                "]]",
                function()
                    Snacks.words.jump(vim.v.count1)
                end,
                desc = "Next Reference",
                mode = { "n", "t" },
            },
            {
                "[[",
                function()
                    Snacks.words.jump(-vim.v.count1)
                end,
                desc = "Prev Reference",
                mode = { "n", "t" },
            },
        },
    },
    {
        -- hl git hunks/stages and keybinds for some git actions
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs_staged = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
        },
    },

    {
        -- folke/which-key.nvim: display available keybindings in a popup
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
        -- grapple.nvim: tag and quickly navigate between files using tags
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
            { "f", mode = { "n", "x", "o" }, desc = "Flash" },
            { "F", mode = { "n", "x", "o" }, desc = "Flash" },
            { "t", mode = { "n", "x", "o" }, desc = "Flash" },
            { "T", mode = { "n", "x", "o" }, desc = "Flash" },
            { ";", mode = { "n", "x", "o" }, desc = "Flash Next" },
        },

        opts = {
            -- labels = "asdfgqwertzxcvb",
            labels = "qwertasdfgzxcvb",
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
    -- {
    --     -- NMAC427/guess-indent.nvim: detect indentation settings per-file automatically
    --     "NMAC427/guess-indent.nvim",
    --     lazy = false,
    --     opts = {},
    -- },
    {
        -- tpope/vim-sleuth: automatically detect and set indentation settings
        "tpope/vim-sleuth",
        lazy = false,
        priority = 900,
    },
}
