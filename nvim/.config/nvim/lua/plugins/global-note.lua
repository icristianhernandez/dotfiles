return {
    -- global-note: easy to use global and extensible markdown notes
    "SuperAPPKid/global-note.nvim",
    cmd = { "GlobalNote", "ProjectPrivateNote" },
    keys = {
        { "<leader>un", "<CMD>GlobalNote<CR>", desc = "Global Notes" },
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

        global_note.setup({
            directory = "~/dotfiles/notes/",

            additional_presets = {
                project_local = {
                    command_name = "ProjectPrivateNote",

                    filename = function()
                        return get_project_name() .. ".md"
                    end,

                    title = function()
                        return get_project_name():sub(1, 1):upper() .. get_project_name():sub(2) .. " [Project Private]"
                    end,
                },
            },
        })
    end,
}
