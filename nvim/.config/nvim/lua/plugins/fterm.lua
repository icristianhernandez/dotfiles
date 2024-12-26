return {
    -- FTerm: create a terminal in a floating window
    "numToStr/FTerm.nvim",
    keys = {
        -- { "<leader>tt", "<cmd>FTermToggle<CR>", mode = "n", desc = "Toggle FTerm" },
        -- { "<Esc>", "<cmd>FTermToggle<CR>", mode = "t", desc = "Toggle FTerm" },
        { "<C-Space>", "<cmd>FTermToggle<CR>", mode = { "t", "n" }, desc = "Toggle FTerm" },
    },
    config = function()
        vim.api.nvim_create_user_command("FTermToggle", require("FTerm").toggle, { bang = true })
        -- require("FTerm").setup()
    end,
}
