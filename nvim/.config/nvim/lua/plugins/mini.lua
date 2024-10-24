return {
    -- mini: collection of short functionatilities
    -- actually used:
    -- trailspace (highlight blank spaces at the end of lines)
    -- files (file manager with oil functionalities)
    -- move (keymaps to move blocks of code)
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,

    config = function()
        require("mini.trailspace").setup()
        require("mini.files").setup({
            windows = {
                preview = true,
            },
        })
        require("mini.move").setup({
            mappings = {
                up = "K",
                down = "J",
                left = "H",
                right = "L",
            },
        })
    end,

    keys = {
        "J",
        "K",
        "H",
        "L",
        -- {
        --     "<leader>ee",
        --     function()
        --         local MiniFiles = require("mini.files")
        --         local _ = MiniFiles.close() or MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        --
        --         vim.schedule(function()
        --             MiniFiles.reveal_cwd()
        --         end, 0)
        --         -- MiniFiles.reveal_cwd()
        --     end,
        --     { noremap = true, silent = true, desc = "Open File Explorer" },
        -- },
    },
}
