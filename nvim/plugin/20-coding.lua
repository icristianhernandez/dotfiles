vim.pack.add({
    "https://github.com/saghen/blink.pairs",
    "https://github.com/saghen/blink.download",
    "https://github.com/RRethy/nvim-treesitter-endwise",
    "https://github.com/windwp/nvim-ts-autotag",
    "https://github.com/echasnovski/mini.move",
    "https://github.com/echasnovski/mini.splitjoin",
    "https://github.com/kylechui/nvim-surround",
    "https://github.com/folke/ts-comments.nvim",
    "https://github.com/kevinhwang91/promise-async",
    "https://github.com/kevinhwang91/nvim-ufo",
})

-- blink.pairs
local blink_pairs_opts = {
    mappings = {
        enabled = true,
        cmdline = true,
        disabled_filetypes = {},
    },
    highlights = {
        enabled = true,
        cmdline = true,
        matchparen = {
            enabled = true,
            cmdline = true,
            include_surrounding = true,
        },
    },
}
local ok, extui = pcall(require, "vim._extui")
if ok and type(extui.enable) == "function" then
    extui.enable({})
else
    blink_pairs_opts.highlights.enabled = false
end
require("blink.pairs").setup(blink_pairs_opts)

-- mini.move
require("mini.move").setup({
    mappings = {
        left = "<S-h>",
        right = "<S-l>",
        down = "<S-j>",
        up = "<S-k>",
    },
})

-- mini.splitjoin
require("mini.splitjoin").setup({
    mappings = {
        toggle = "gs",
    },
})

-- nvim-surround
vim.g.nvim_surround_no_visual_mappings = true
require("nvim-surround").setup({})
vim.keymap.set("x", "ñ", "<Plug>(nvim-surround-visual)", {
    desc = "Add a surrounding pair around a visual selection",
})

-- ts-comments.nvim
require("ts-comments").setup({})

-- nvim-ufo
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
require("ufo").setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
    end,
})

-- nvim-ts-autotag
require("nvim-ts-autotag").setup({})
