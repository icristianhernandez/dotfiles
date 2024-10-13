return {
    "echasnovski/mini.files",
    version = false,
    keys = {
        -- {
        --     "<leader><leader>",
        --     "<cmd>lua MiniFiles.open()<CR>",
        --     { noremap = true, silent = true, desc = "Open File Explorer" },
        -- },
        {
            "<leader><leader>",
            function()
                local MiniFiles = require("mini.files")
                local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)

                -- vim.schedule(function()
                --     MiniFiles.reveal_cwd()
                -- end, 0)
                MiniFiles.reveal_cwd()
            end,
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
