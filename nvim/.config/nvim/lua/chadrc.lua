return {
    ui = {
        statusline = {
            theme = "minimal",
            order = { "mode", "file", "modified", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
            modules = {
                modified = " %m ",
            },
        },

        tabufline = {
            enabled = true,
            order = { "tabs" },
        },

        telescope = {
            style = "bordered",
        },

        cmp = {
            icons_left = true,
            style = "atom_colored",
        },
    },
}
