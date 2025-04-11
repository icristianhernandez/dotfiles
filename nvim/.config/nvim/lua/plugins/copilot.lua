return {
    -- copilot: IA autocompletion
    "zbirenbaum/copilot.lua",

    opts = {
        copilot_model = "gpt-4o-copilot",
        suggestion = {
            auto_trigger = false,
            debounce = 20,
            keymap = {
                accept = "<C-r>",
            },
        },
    },
}
