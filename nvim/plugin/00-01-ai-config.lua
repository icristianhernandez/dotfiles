vim.pack.add({
    "https://github.com/zbirenbaum/copilot.lua",
    "https://github.com/NickvanDyke/opencode.nvim",
})

-- opencode.nvim config (contributing to snacks)
Pack.add_config("snacks.nvim", {
    picker = {
        actions = {
            opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
        },
        win = {
            input = {
                keys = { ["<a-a>"] = { "opencode_send", mode = { "n", "i" } } },
            },
        },
    },
})
