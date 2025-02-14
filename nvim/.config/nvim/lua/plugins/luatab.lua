return {
    -- luatab: A simple and clean tabline plugin for neovim
    "alvarosevilla95/luatab.nvim",
    lazy = true,
    event = { "TabEnter", "TabNew" }, -- added TabNew event

    opts = {
        windowCount = function()
            return " "
        end,
    },
}
