vim.pack.add({
    "https://github.com/f-person/auto-dark-mode.nvim",
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    "https://github.com/sainnhe/everforest",
})

vim.opt.fillchars:append({ eob = " " })

require("auto-dark-mode").setup({
    set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        -- vim.cmd.colorscheme("everforest")
    end,
    set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        -- vim.cmd.colorscheme("catppuccin-nvim")
    end,
})

if vim.opt.background:get() == "dark" then
    vim.cmd.colorscheme("catppuccin-nvim")
else
    vim.cmd.colorscheme("catppuccin-nvim")
end

vim.g.everforest_background = "hard"
vim.g.everforest_enable_italic = true

require("catppuccin").setup({
    term_colors = true,
    -- transparent_background = true,
    -- float = {
    --     -- transparent = true,
    --     solid = true,
    -- },
    background = {
        light = "latte",
        dark = "macchiato",
    },
    default_integration = true,
    auto_integrations = true,
    -- integrations = {},
})
