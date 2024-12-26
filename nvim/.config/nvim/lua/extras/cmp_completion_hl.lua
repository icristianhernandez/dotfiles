local function hex_to_rgb(hex)
    return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

local function rgb_to_hex(r, g, b)
    return string.format("#%02x%02x%02x", r, g, b)
end

local function blend_color(hex_fg_color, hex_bg_color, alpha)
    local fg_r, fg_g, fg_b = hex_to_rgb(hex_fg_color)
    local bg_r, bg_g, bg_b = hex_to_rgb(hex_bg_color)

    local r = math.floor(fg_r * alpha + bg_r * (1 - alpha))
    local g = math.floor(fg_g * alpha + bg_g * (1 - alpha))
    local b = math.floor(fg_b * alpha + bg_b * (1 - alpha))

    return rgb_to_hex(r, g, b)
end

local function lightnen_color(hex_color, alpha)
    local r, g, b = hex_to_rgb(hex_color)

    r = math.floor(r + (255 - r) * alpha)
    g = math.floor(g + (255 - g) * alpha)
    b = math.floor(b + (255 - b) * alpha)

    return rgb_to_hex(r, g, b)
end

local function get_hex_fg_hl(hl_name)
    local hl = vim.api.nvim_get_hl_by_name(hl_name, true) or {}

    if not hl or not hl.foreground then
        return nil
    end

    return string.format("#%06x", hl.foreground)
end

local function cmp_icons_colors()
    -- vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
    -- vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

    vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { link = "Comment" })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { link = "Search" })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "Search" })
    vim.api.nvim_set_hl(0, "CmpItemMenu", { link = "Special" })

    local hl_groups = {
        { "CmpItemKindField", "Type" },
        { "CmpItemKindProperty", "Type" },
        { "CmpItemKindEvent", "Type" },
        { "CmpItemKindText", "String" },
        { "CmpItemKindEnum", "String" },
        { "CmpItemKindKeyword", "Keyword" },
        { "CmpItemKindConstant", "Constant" },
        { "CmpItemKindConstructor", "Function" },
        { "CmpItemKindReference", "Constant" },
        { "CmpItemKindFunction", "Function" },
        { "CmpItemKindStruct", "Structure" },
        { "CmpItemKindClass", "Structure" },
        { "CmpItemKindModule", "Structure" },
        { "CmpItemKindOperator", "Operator" },
        { "CmpItemKindVariable", "Identifier" },
        { "CmpItemKindFile", "Directory" },
        { "CmpItemKindUnit", "Number" },
        { "CmpItemKindSnippet", "Special" },
        { "CmpItemKindFolder", "Directory" },
        { "CmpItemKindMethod", "Function" },
        { "CmpItemKindValue", "Number" },
        { "CmpItemKindEnumMember", "Number" },
        { "CmpItemKindInterface", "Type" },
        { "CmpItemKindColor", "Special" },
        { "CmpItemKindTypeParameter", "Type" },
    }

    for _, group in ipairs(hl_groups) do
        local fg_color = get_hex_fg_hl(group[2])
        local pmenu_bg = vim.api.nvim_get_hl_by_name("Pmenu", true).background
        pmenu_bg = string.format("#%06x", pmenu_bg)

        if fg_color then
            -- all same colors:
            -- fg_color = lightnen_color(fg_color, 0.45)
            -- local bg_color = blend_color(fg_color, pmenu_bg, 0.5)
            -- vim.api.nvim_set_hl(0, group[1], { fg = fg_color, bg = bg_color })

            -- white fg
            -- fg_color = lightnen_color(fg_color, 0.2)
            -- pmenu_bg = lightnen_color(pmenu_bg, 0.2)
            local bg_color = blend_color(fg_color, pmenu_bg, 0.4)
            vim.api.nvim_set_hl(0, group[1], { fg = "#FFFFFF", bg = bg_color })
        end
    end
end

-- autocmd of the icons highlight when colorscheme changed
cmp_icons_colors()
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        cmp_icons_colors()
    end,
})
