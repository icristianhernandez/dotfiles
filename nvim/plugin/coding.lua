vim.pack.add({
    "https://github.com/RRethy/nvim-treesitter-endwise",
    "https://github.com/windwp/nvim-ts-autotag",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/kylechui/nvim-surround",
    "https://github.com/folke/ts-comments.nvim",

    --
    "https://github.com/kevinhwang91/promise-async",
    "https://github.com/kevinhwang91/nvim-ufo",

    --
    "https://github.com/saghen/blink.download",
    {
        src = "https://github.com/saghen/blink.pairs",
        version = vim.version.range("*"),
    },
})

require("nvim-ts-autotag").setup()

require("mini.move").setup({
    mappings = {
        left = "<S-h>",
        right = "<S-l>",
        down = "<S-j>",
        up = "<S-k>",
    },
})

require("mini.splitjoin").setup({
    mappings = {
        toggle = "gs",
    },
})

vim.g.nvim_surround_no_visual_mappings = true
vim.keymap.set("x", "ñ", "<Plug>(nvim-surround-visual)", {
    desc = "Add a surrounding pair around a visual selection",
})

require("ts-comments").setup()

vim.o.foldcolumn = "0"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

require("ufo").setup({
    provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
    end,
})

local ok, extui = pcall(require, "vim._extui")
local highlights_enabled = true
if ok and type(extui.enable) == "function" then
    extui.enable({})
else
    highlights_enabled = false
end

require("blink.pairs").setup({
    mappings = {
        enabled = true,
        cmdline = true,
        disabled_filetypes = {},
    },
    highlights = {
        enabled = highlights_enabled,
        cmdline = false,
        matchparen = {
            enabled = true,
            cmdline = true,
            include_surrounding = true,
        },
    },
})
