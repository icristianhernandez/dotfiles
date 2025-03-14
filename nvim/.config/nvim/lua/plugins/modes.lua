return {
    "mvllow/modes.nvim",
    lazy = true,
    -- Ideally, only with ModeChanged it's enough, but the effect only appears
    -- after the first mode change, so we need to trigger it on BufWinEnter and
    event = { "ModeChanged", "BufWinEnter", "WinEnter" },

    config = function()
        require("modes").setup({
            line_opacity = 0.15,
        })

        local blend_rate_default = vim.o.background == "dark" and 0.55 or 0.65
        local blend_rate_visual_dark = 0.78
        local blend_rate_insert_light = 0.85
        local blend_rate_visual_light = 0.88 -- new blend rate for visual mode in light mode

        local colors_helpers = require("utilities.colors_helpers")
        local modes = { "Copy", "Insert", "Visual", "Delete" }

        local function applyBlendedHighlight(base, blend_rate, target_hl)
            local default_bg = colors_helpers.get_bg_color_hex(base)
            local cursor_bg = colors_helpers.get_bg_color_hex(base .. "CursorLine")
            local blended = colors_helpers.blend_colors_hex(default_bg, cursor_bg, blend_rate)
            -- local hl_target = target_hl or (base .. "CursorLineNr")
            local hl_target = target_hl or (base .. "CursorLineNr")
            vim.api.nvim_set_hl(0, hl_target, { bg = blended })
            vim.api.nvim_set_hl(0, base .. "CursorLineSign", { bg = blended })
        end

        local function adjustModeContrastLocal()
            for _, mode in ipairs(modes) do
                local mode_base = "Modes" .. mode
                applyBlendedHighlight(mode_base, blend_rate_default)
            end
            if vim.o.background == "dark" then
                applyBlendedHighlight("ModesVisual", blend_rate_visual_dark, "ModesVisualVisual")
                applyBlendedHighlight("ModesVisual", blend_rate_visual_dark)
            elseif vim.o.background == "light" then
                applyBlendedHighlight("ModesVisual", blend_rate_visual_light, "ModesVisualVisual")
                applyBlendedHighlight("ModesVisual", blend_rate_visual_dark)
                applyBlendedHighlight("ModesInsert", blend_rate_insert_light)
            end
        end

        adjustModeContrastLocal()

        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = adjustModeContrastLocal,
        })
    end,
}
