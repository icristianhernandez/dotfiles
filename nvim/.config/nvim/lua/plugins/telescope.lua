return {
    -- telescope: fuzzy finder for a lot of things (files, buffers, git, etc)
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
            "debugloop/telescope-undo.nvim",
            keys = {
                {
                    "<leader>fu",
                    "<cmd>Telescope undo<cr>",
                    desc = "undo history",
                },
            },
            config = function()
                require("telescope").load_extension("undo")
            end,
        },
        {
            "xiyaowong/telescope-emoji.nvim",
            keys = {
                {
                    "<leader>fe",
                    "<cmd>Telescope emoji<cr>",
                    desc = "emoji",
                },
            },
            config = function()
                require("telescope").load_extension("emoji")
            end,
        },
    },

    keys = {
        { "<leader>ff", ":Telescope find_files<CR>", desc = "Find files", silent = true },
        { "<leader>fg", ":Telescope live_grep<CR>", desc = "Live grep", silent = true },
        -- grep in current directory
        {
            "<leader>fG",
            ":Telescope live_grep cwd=<c-r>=expand('%:p:h')<cr><CR>",
            desc = "Live grep in current directory",
            silent = true,
        },
        {
            "<leader>fb",
            ":Telescope buffers<CR>",
            desc = "Telescope Buffers",
            silent = true,
        },
        { "<leader>fh", ":Telescope help_tags<CR>", desc = "Help tags", silent = true },
        {
            "<leader>fa",
            ":Telescope find_files follow=true no_ignore=true hidden=true<CR>",
            desc = "Find files (all)",
            silent = true,
        },
        {
            "<leader>fr",
            ":Telescope resume<CR>",
            desc = "Resume last telescope session",
            silent = true,
        },
        {
            "<leader>gb",
            ":Telescope git_branches<CR>",
            desc = "Git branches",
            silent = true,
        },
    },

    config = function()
        local actions = require("telescope.actions")

        require("telescope").setup({
            defaults = {
                file_ignore_patterns = { ".git/", "node_modules/", "vendor/" },

                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                        ["<tab>"] = actions.move_selection_next,
                        ["<s-tab>"] = actions.move_selection_previous,
                    },
                    n = {
                        ["<tab>"] = actions.move_selection_next,
                        ["<s-tab>"] = actions.move_selection_previous,
                    },
                },

                layout_strategy = "vertical",
                layout_config = {
                    prompt_position = "top",
                    preview_cutoff = 0,
                    -- center = { width = 0.7, height = 0.45, anchor = "N", },
                    -- vertical = { mirror = true, },
                },

                sorting_strategy = "ascending",
                initial_mode = "insert",

                path_display = { "truncate", truncate = 5 },

                prompt_prefix = " ",
                -- selection_caret = "  ",
                selection_caret = "  ",

                entry_prefix = " ",
                borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            },
        })
    end,
}
