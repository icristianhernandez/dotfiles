-- Todo:
--  - Add a way to toggle between themes
--  - Add colors to the [+] in the lualine
--  - Create a new module for the tabline that show only the [1] [2], not the
--      buttons
local M = {}

M.base46 = {
    theme = "rosepine",
    theme_toggle = { "rosepine", "one_light" },
}

M.ui = {
    statusline = {
        theme = "vscode_colored",
        order = {
            "mode",
            "file",
            "modified",
            "git",
            "%=",
            "lsp_msg",
            "%=",
            "diagnostics",
            "lsp",
            "cwd",
            "cursor",
        },
        modules = {
            modified = " %m ",
        },
    },

    tabufline = {
        enabled = true,
        order = { "tabs" },
    },

    telescope = {
        -- style = "bordered",
    },

    cmp = {
        icons_left = true,
        style = "atom_colored",
    },
}

M.colorify = {
    mode = "bg",
}

return M

-- return {
--     ui = {
--         statusline = {
--             theme = "minimal",
--             order = { "mode", "file", "modified", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
--             modules = {
--                 modified = " %m ",
--             },
--         },
--
--         tabufline = {
--             enabled = true,
--             order = { "tabs" },
--         },
--
--         telescope = {
--             style = "bordered",
--         },
--
--         cmp = {
--             icons_left = true,
--             style = "atom_colored",
--         },
--     },
-- }
