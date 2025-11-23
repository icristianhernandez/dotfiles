return {
    "folke/snacks.nvim",

    ---@module "snacks"
    ---@type snacks.Config
    opts = {
        styles = {
            scratch = {
                relative = "editor",
                min_height = 18,
                height = 0.85,
                width = 0.85,
            },
        },
    },

    keys = {
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
        { "<leader>.", false },
    },
}
