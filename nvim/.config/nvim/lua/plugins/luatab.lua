return {
    -- luatab: A simple and clean tabline plugin for neovim
    "alvarosevilla95/luatab.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
        require("luatab").setup({
            windowCount = function()
                return " "
            end,
        })
    end,
}
