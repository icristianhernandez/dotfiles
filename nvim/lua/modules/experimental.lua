return {
    -- {
    --     -- tadaa/vimade: animated scrollbars for Neovim
    --     "tadaa/vimade",
    --     event = "VeryLazy",
    --     opts = {
    --         recipe = { "default", { animate = false } },
    --         fadelevel = 0.25,
    --     },
    -- },
    -- {
    --     -- sphamba/smear-cursor.nvim: cursor smear animation for motion feedback
    --     "sphamba/smear-cursor.nvim",
    --     event = "VeryLazy",
    --     cond = vim.g.neovide == nil,
    --     opts = {
    --         -- never_draw_over_target = true,
    --     },
    -- },
    {
        -- shortcuts/no-neck-pain.nvim: center the text area in Neovim
        "shortcuts/no-neck-pain.nvim",
        opts = {
            width = 98,
            buffers = {
                wo = { sidescrolloff = 0 },
                left = { wo = { sidescrolloff = 0 } },
                right = { wo = { sidescrolloff = 0 } },
            },
            autocmds = {
                -- enableOnVimEnter = true,
                -- enableOnTabEnter = true,
                reloadOnColorSchemeChange = true,
                skipEnteringNoNeckPainBuffer = true,
            },
            mappings = {
                enabled = false,
                toggle = "<leader>un",
                toggleLeftSide = false,
                toggleRightSide = false,
                widthUp = false,
                widthDown = false,
                scratchPad = false,
            },
        },
        keys = {
            {
                "<leader>un",
                function()
                    require("no-neck-pain").toggle()
                end,
                desc = "Toggle NoNeckPain",
            },
        },
    },
    {
        -- nvim-pack/nvim-spectre: project-wide find & replace in a panel
        "nvim-pack/nvim-spectre",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            open_cmd = function()
                local buf = vim.api.nvim_create_buf(false, true)
                local width = math.max(60, math.floor(vim.o.columns * 0.85))
                local height = math.max(10, math.floor(vim.o.lines * 0.6))
                local row = math.floor((vim.o.lines - height) / 2)
                local col = math.floor((vim.o.columns - width) / 2)

                vim.api.nvim_open_win(buf, true, {
                    relative = "editor",
                    width = width,
                    height = height,
                    row = row,
                    col = col,
                    style = "minimal",
                    border = "rounded",
                })
            end,

            mapping = {
                close = {
                    map = "q",
                    cmd = "<cmd>lua require('spectre').close()<CR>",
                    desc = "Close Spectre",
                },
            },

            default = {
                -- find = { options = { "ignore-case", "hidden" } },
                find = { options = { "ignore-case" } },
            },
        },
        keys = {
            {
                "<leader>sf",
                function()
                    require("spectre").toggle()
                end,
                desc = "Toggle Spectre",
            },
            {
                "<leader>sw",
                function()
                    require("spectre").open_visual({ select_word = true })
                end,
                mode = { "n", "x" },
                desc = "Spectre: Search current word",
            },
            {
                "<leader>sp",
                function()
                    require("spectre").open_file_search({ select_word = false })
                end,
                mode = { "n", "x" },
                desc = "Spectre: Search in current file",
            },
        },
    },
    -- {
    --     -- andymass/vim-matchup: enhanced % matching for Vim/Neovim
    --     "andymass/vim-matchup",
    --     dependencies = {
    --         { "nvim-treesitter/nvim-treesitter" },
    --     },
    --
    --     init = function()
    --         vim.g.matchup_matchparen_offscreen = { method = "popup" }
    --         vim.g.matchup_transmute_enabled = 1
    --         vim.g.matchup_matchparen_deferred = 1
    --         vim.g.matchup_delim_noskips = 2
    --         vim.g.matchup_matchparen_stopline = 200
    --
    --         vim.keymap.set(
    --             "n",
    --             "<leader>ci",
    --             "<plug>(matchup-hi-surround)",
    --             { desc = "Highlight actual surround", silent = true }
    --         )
    --     end,
    -- },
    -- lazy.nvim
    {
        -- chrisgrieser/nvim-recorder: record and replay macros with an easy-to-use UI
        "chrisgrieser/nvim-recorder",
        opts = {
            -- lessNotifications = true,
        },
    },
    -- {
    --     -- subtle animations for Neovim actions (search, undo, redo, yank, etc.)
    --     "rachartier/tiny-glimmer.nvim",
    --     lazy = false,
    --     opts = {
    --         autoreload = true,
    --         overwrite = {
    --             search = {
    --                 enabled = true,
    --                 default_animation = {
    --                     name = "left_to_right",
    --                     settings = {
    --                         from_color = "DiffDelete",
    --                         max_duration = 150,
    --                         min_duration = 150,
    --                     },
    --                 },
    --             },
    --             undo = {
    --                 enabled = true,
    --             },
    --             redo = {
    --                 enabled = true,
    --             },
    --         },
    --     },
    -- },
    {
        -- stevearc/overseer.nvim: task runner for ad-hoc commands
        "stevearc/overseer.nvim",
        opts = function()
            local repo_root = vim.fn.expand("~") .. "/dotfiles"
            local script_name = "git-auto-commit-opencode.sh"
            local script_path = (vim.fs and vim.fs.joinpath(repo_root, "scripts", script_name)) or (repo_root .. "/scripts/" .. script_name)

            local overseer = require("overseer")

            overseer.register_template({
                name = "Auto commit with OpenCode",
                builder = function()
                    return {
                        cmd = { "bash", script_path },
                        cwd = repo_root,
                        name = "auto-commit-opencode",
                    }
                end,
            })

            if vim.fn.filereadable(script_path) == 0 then
                vim.notify(
                    string.format("overseer: script not found at %s", script_path),
                    vim.log.levels.WARN
                )
            end

            return {}
        end,
        keys = {
            {
                "<leader>al",
                function()
                    vim.notify("overseer: starting auto-commit task", vim.log.levels.INFO)
                    require("overseer").run_task({ name = "Auto commit with OpenCode" }, function(task, err)
                        if not task then
                            vim.notify("overseer: failed to run task: " .. tostring(err or "unknown"), vim.log.levels.ERROR)
                            return
                        end
                    end)
                end,
                desc = "Run auto-commit script",
            },
            {
                "<leader>tt",
                function()
                    require("overseer").toggle()
                end,
                desc = "Toggle Overseer task list",
            },
        },
    },
}
