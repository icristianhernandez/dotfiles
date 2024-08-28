return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPre",
    ---@module "ibl"
    ---@type ibl.config
    config = function()
        require("ibl").setup({
            indent = {
                char = "▏",
            },
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
            },
            exclude = {
                buftypes = { "terminal" },
            },
        })
    end,
}
