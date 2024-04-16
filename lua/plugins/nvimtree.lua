return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,

    keys = {
        { "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle tree", silent = true },
    },

    opts = {
        actions = {
            open_file = {
                quit_on_open = true,
                resize_window = true, -- Optional: Resize window after opening file
            },
        },
    },
}
