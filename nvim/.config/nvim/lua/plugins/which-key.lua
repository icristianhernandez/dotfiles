return {
    -- which-key: cheatsheet for keybindings when pressing a key
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("which-key").setup({
            preset = "helix",
            plugins = {
                presets = {
                    motions = false,
                },
            },
        })
    end,
}
