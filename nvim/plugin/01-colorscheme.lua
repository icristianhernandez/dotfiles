vim.pack.add({
    "https://github.com/f-person/auto-dark-mode.nvim",
    "https://github.com/catppuccin/nvim",
})

require("auto-dark-mode").setup({
    set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
    end,
    set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
    end,
})

require("catppuccin").setup({
    term_colors = true,
    float = {
        solid = true,
    },
    background = {
        light = "latte",
        dark = "macchiato",
    },
    default_integration = false,
    auto_integrations = true,
    integrations = {},
})

vim.cmd("colorscheme catppuccin-nvim")
vim.opt.fillchars:append({ eob = " " })
