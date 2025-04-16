return {
    -- luatab: A simple and clean tabline plugin for neovim
    "alvarosevilla95/luatab.nvim",
    lazy = true,
    event = { "TabEnter", "TabNew" },

    opts = {
        windowCount = function()
            return " "
        end,
    },
}
