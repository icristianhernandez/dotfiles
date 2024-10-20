return {
    -- nvim-colorizer: highlight the background of color codes
    -- "norcalli/nvim-colorizer.lua",
    -- none of these are well maintaned
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
        require("colorizer").setup({
            user_default_options = {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = true, -- "Name" codes like Blue or blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                AARRGGBB = true, -- 0xAARRGGBB hex codes
                rgb_fn = true, -- CSS rgb() and rgba() functions
                hsl_fn = true, -- CSS hsl() and hsla() functions
                css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                saas = { enable = true },
                always_update = true, -- update colors if colorscheme changes
            },
        })
    end,
}
