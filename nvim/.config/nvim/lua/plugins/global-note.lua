return {
    -- global-note: easy to use global and extensible markdown notes
    "SuperAPPKid/global-note.nvim",
    cmd = { "GlobalNote", "ProjectPrivateNote" },
    keys = {
        { "<C-n>", "<CMD>GlobalNote<CR>", desc = "Global Notes" },
        { "<leader>un", "<CMD>GlobalNote<CR>", desc = "Global Notes" },
        { "<C-ñ>", "<CMD>ProjectPrivateNote<CR>", desc = "Private Notes" },
        { "<leader>uN", "<CMD>ProjectPrivateNote<CR>", desc = "Private Notes" },
    },

    config = function()
        local global_note = require("global-note")

        local get_project_name = function()
            local project_directory, err = vim.loop.cwd()
            if project_directory == nil then
                vim.notify(err, vim.log.levels.WARN)
                return nil
            end

            local project_name = vim.fs.basename(project_directory)
            if project_name == nil then
                vim.notify("Unable to get the project name", vim.log.levels.WARN)
                return nil
            end

            return project_name
        end

        local get_project_parent_name = function()
            local project_directory, err = vim.loop.cwd()
            if project_directory == nil then
                vim.notify(err, vim.log.levels.WARN)
                return nil
            end

            local project_parent_name = vim.fn.fnamemodify(vim.fn.fnamemodify(project_directory, ":h"), ":t")
            if project_parent_name == nil then
                vim.notify("Unable to get the project parent name", vim.log.levels.WARN)
                return nil
            end

            return project_parent_name
        end

        local note_name = function()
            -- implement with: project_parent + _ + project_name + .md
            return get_project_parent_name() .. "_" .. get_project_name() .. ".md"
        end

        local note_title = function()
            return get_project_name():sub(1, 1):upper() .. get_project_name():sub(2) .. " [Project Private]"
        end

        global_note.setup({
            directory = "~/dotfiles/notes/",
            post_open = function(note_buffer_id, note_window_id)
                -- stolen from 'JellyApple102/flote.nvim'
                local current_buf = vim.api.nvim_win_get_buf(0)
                local cmd = "<cmd>wq<CR>"

                if vim.bo[current_buf].readonly then
                    cmd = "<cmd>q!<CR>"
                end

                vim.api.nvim_buf_set_keymap(note_buffer_id, "n", "q", cmd, { noremap = true, silent = false })
            end,

            additional_presets = {
                project_local = {
                    command_name = "ProjectPrivateNote",

                    -- filename = function()
                    --     return get_project_name() .. ".md"
                    -- end,

                    filename = note_name,

                    title = note_title,
                },
            },
        })
    end,
}

-- return {
--     -- flote: Easily accessible, per-project markdown notes in Neovim.
--     "JellyApple102/flote.nvim",
--     cmd = { "Flote", "Flote global", "Flote manage" },
--     keys = {
--         { "<leader>un", "<CMD>Flote<CR>", desc = "Flote" },
--         { "<leader>uN", "<CMD>Flote global<CR>", desc = "Flote global" },
--         { "<leader>um", "<CMD>Flote manage<CR>", desc = "Flote manage" },
--     },
--     config = function()
--         require("flote").setup({
--             q_to_quit = true,
--             window_style = "minimal",
--             window_border = "solid",
--             window_title = true,
--             notes_dir = "~/dotfiles/notes/",
--             files = {
--                 global = "flote-global.md",
--                 cwd = function()
--                     return vim.fn.getcwd()
--                 end,
--                 file_name = function(cwd)
--                     local base_name = vim.fs.basename(cwd)
--                     local parent_base_name = vim.fs.basename(vim.fs.dirname(cwd))
--                     return parent_base_name .. "_" .. base_name .. ".md"
--                 end,
--             },
--         })
--     end,
-- }
