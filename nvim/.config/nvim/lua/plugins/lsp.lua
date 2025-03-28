vim.g.lazyvim_python_lsp = "basedpyright"

return {
    "neovim/nvim-lspconfig",
    opts = {
        diagnostics = {
            virtual_text = false,
            inlay_hints = {
                enabled = false,
            },
        },

        -- servers = {
        --     marksman = {},
        -- },
    },
}
