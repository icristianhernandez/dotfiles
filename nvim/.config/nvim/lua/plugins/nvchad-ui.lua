return {
    "nvchad/ui",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvchad/volt",
        {
            "nvchad/base46",
            lazy = true,

            build = function()
                require("base46").load_all_highlights()
            end,

            config = function()
                for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
                    dofile(vim.g.base46_cache .. v)
                end
            end,
        },
    },

    config = function()
        require("nvchad")
        -- set the keymap
        vim.api.nvim_set_keymap(
            "n",
            "<leader>ft",
            "<cmd> lua require('nvchad.themes').open()<CR>",
            { noremap = true, silent = true }
        )
    end,
}
