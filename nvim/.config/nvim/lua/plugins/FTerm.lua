return {
    "numToStr/FTerm.nvim",
    keys = {
        { "<leader>t", "<cmd>FTermToggle<CR>", mode = "n", desc = "Toggle FTerm" },
        { "<Esc>", "<cmd>FTermToggle<CR>", mode = "t", desc = "Toggle FTerm" },
    },
    config = function()
        vim.api.nvim_create_user_command('FTermToggle', require('FTerm').toggle, { bang = true })
        -- require("FTerm").setup()
    end,
}
