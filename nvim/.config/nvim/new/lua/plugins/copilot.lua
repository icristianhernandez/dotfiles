return {
    -- copilot: IA autocompletion
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",

    opts = {
        suggestion = {
            auto_trigger = false,
            debounce = 20,
            keymap = {
                accept = "<C-r>",
            },
        },
        panel = { enabled = false },
        filetypes = {
            ["*"] = true,
        },
    },
}
