return {
    "echasnovski/mini.files",
    version = false,
    keys = {
        {
            "<leader><leader>",
            "<cmd>lua MiniFiles.open()<CR>",
            { noremap = true, silent = true, desc = "Open File Explorer" },
        },
    },
    config = function()
        require("mini.files").setup({
            windows = {
                preview = true,
            },
        })
    end,
}
