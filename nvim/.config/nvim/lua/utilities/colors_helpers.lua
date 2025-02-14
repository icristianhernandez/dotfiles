local M = {}

function M.hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return {
        r = tonumber(hex:sub(1, 2), 16),
        g = tonumber(hex:sub(3, 4), 16),
        b = tonumber(hex:sub(5, 6), 16),
    }
end

function M.rgb_to_hex(rgb)
    return string.format("#%02x%02x%02x", rgb.r, rgb.g, rgb.b)
end

function M.blend_colors_hex(fg, bg, alpha)
    local fg_rgb = M.hex_to_rgb(fg)
    local bg_rgb = M.hex_to_rgb(bg)
    local blended_rgb = {
        r = (1 - alpha) * fg_rgb.r + alpha * bg_rgb.r,
        g = (1 - alpha) * fg_rgb.g + alpha * bg_rgb.g,
        b = (1 - alpha) * fg_rgb.b + alpha * bg_rgb.b,
    }
    return M.rgb_to_hex(blended_rgb)
end

function M.set_highlight_hex(hl_group, opts)
    vim.api.nvim_set_hl(0, hl_group, opts)
end

function M.get_bg_color_hex(hl_group)
    local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false })
    local color = hl.bg or 0x000000
    return string.format("#%06x", color)
end

return M
