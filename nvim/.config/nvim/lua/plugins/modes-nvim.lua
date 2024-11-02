return {
    -- modes: highlight the cursorline based on the mode
    "mvllow/modes.nvim",
    event = { "ModeChanged", "BufWinEnter", "WinEnter" },
    config = function()
        require("modes").setup({
            line_opacity = 0.15,
        })

        -- cursorline number highlight
        -- highlight groups to change:
        -- ModesCopyCursorLineNr
        -- ModesInsertCursorLineNr
        -- ModesVisualCursorLineNr
        -- ModesDeleteCursorLineNr
        local function set_highlight(hl_group, fg, bg)
            vim.api.nvim_set_hl(0, hl_group, { fg = fg, bg = bg })
        end

        local function set_bg(hl_group, bg)
            vim.api.nvim_set_hl(0, hl_group, { bg = bg })
        end

        local bit = require("bit")

        local function hex_to_rgb(hex)
            hex = hex:gsub("#", "")
            return {
                r = tonumber(hex:sub(1, 2), 16),
                g = tonumber(hex:sub(3, 4), 16),
                b = tonumber(hex:sub(5, 6), 16),
            }
        end

        local function rgb_to_hex(rgb)
            return string.format("#%02x%02x%02x", rgb.r, rgb.g, rgb.b)
        end

        local function get_bg(hl_group)
            local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
            local color = hl.bg or 0x000000 -- default to black if not set
            return string.format("#%06x", color)
        end

        local function blend(fg, bg, alpha)
            local fg_rgb = hex_to_rgb(fg)
            local bg_rgb = hex_to_rgb(bg)
            local blended_rgb = {
                r = (1 - alpha) * fg_rgb.r + alpha * bg_rgb.r,
                g = (1 - alpha) * fg_rgb.g + alpha * bg_rgb.g,
                b = (1 - alpha) * fg_rgb.b + alpha * bg_rgb.b,
            }
            return rgb_to_hex(blended_rgb)
        end

        local function set_cursorline_number_hl(mode)
            local cursorline_color = get_bg("Modes" .. mode)
            local cursorline_bg = get_bg("Modes" .. mode .. "CursorLine")

            local blend_rate = vim.o.background == "dark" and 0.55 or 0.65
            local cursorline_number_bg = blend(cursorline_color, cursorline_bg, blend_rate)

            set_bg("Modes" .. mode .. "CursorLineNr", cursorline_number_bg)
            set_bg("Modes" .. mode .. "CursorLineSign", cursorline_number_bg)
        end

        local modes = { "Copy", "Insert", "Visual", "Delete" }

        for _, mode in ipairs(modes) do
            set_cursorline_number_hl(mode)
        end

        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                for _, mode in ipairs(modes) do
                    set_cursorline_number_hl(mode)
                end
            end,
        })
    end,
}
