return {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
    config = function()
        require("lsp_signature").setup({
            doc_lines = 1,
            floating_window = true,
            hint_enable = true,

            timer_interval = 50,
            always_trigger = true,

            hint_prefix = {
                above = "↙ ", -- when the hint is on the line above the current line
                current = "← ", -- when the hint is on the same line
                below = "↖ ", -- when the hint is on the line below the current line
            },

            handler_opts = {
                border = "single",
            },
        })
    end,
}
