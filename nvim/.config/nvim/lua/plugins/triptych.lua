return {
    "simonmclean/triptych.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "nvim-tree/nvim-web-devicons", -- optional
    },
    keys = {
        -- { "<leader>ee", ":Triptych<CR>", { noremap = true, silent = true, desc = "File Explorer" } },
        { "<leader>eE", ":Triptych<CR>", { noremap = true, silent = true, desc = "File Explorer" } },
    },
    config = function()
        require("triptych").setup({
            mappings = {
                -- Everything below is buffer-local, meaning it will only apply to Triptych windows
                show_help = "g?",
                jump_to_cwd = ".", -- Pressing again will toggle back
                nav_left = "h",
                nav_right = { "l", "<CR>" }, -- If target is a file, opens the file in-place
                open_hsplit = { "-" },
                open_vsplit = { "|" },
                open_tab = { "<C-t>" },
                cd = "<leader>cd",
                delete = "d",
                add = "a",
                copy = "c",
                rename = "r",
                cut = "x",
                paste = "p",
                quit = "q",
                toggle_hidden = "<leader>.",
                toggle_collapse_dirs = "z",
            },
            options = {
                syntax_highlighting = {
                    -- enabled = false,
                    debounce_ms = 200,
                },
                responsive_column_widths = {
                    -- ["0"] = { 0, 0.5, 0.5 },
                    ["0"] = { 0.2, 0.4, 0.4 },
                    ["200"] = { 0.25, 0.25, 0.5 },
                },
                backdrop = 100,
            },
        })
    end,
}
