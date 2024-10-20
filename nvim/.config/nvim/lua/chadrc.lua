-- Todo:
--  - Add a way to toggle between themes
--  - Add colors to the [+] in the lualine
--  - Create a new module for the tabline that show only the [1] [2], not the
--      buttons
--  - or view what to do with the tabline, for example not use tabs
--  - Light/dark auto toggle (changed based of background color)
--  - add terminals

-- takes: not replaced vim.ui.select / input hooks
local M = {}

M.base46 = {
    theme = "one_light",
    theme_toggle = { "one_light", "one_light" },
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
        enabled = false,
        order = { "treeOffset", "tabs" },
    },

    telescope = {
        -- style = "bordered",
    },

    cmp = {
        style = "atom_colored",
    },
}

M.colorify = {
    mode = "bg",
}

return M
