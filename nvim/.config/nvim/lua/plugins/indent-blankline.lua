return {
    -- indent-blankline: show vertical lines to indicate indentation levels and
    -- highlight the current indent depth.
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPre",
    config = function()
        require("ibl").setup({
            indent = {
                char = "▏",
                smart_indent_cap = true,
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = true,
            },
            exclude = {
                buftypes = { "terminal" },
            },
        })
    end,
}
