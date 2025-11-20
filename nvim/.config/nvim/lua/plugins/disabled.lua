-- Disabled LazyVim plugins and temporary additions
return {
    -- Disabled LazyVim plugins
    { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },
    { "akinsho/bufferline.nvim", enabled = false },
    -- mini.files replace:
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
    -- auto-session replace:
    { "folke/persistence.nvim", enabled = false },
    -- ultimate-autopair replace:
    { "echasnovski/mini.pairs", enabled = false },

    -- Temporary plugins (for testing or temporary use)
    { "EddyBer16/pseint.vim" },
}
