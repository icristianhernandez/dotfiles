vim.pack.add({
    "https://github.com/zbirenbaum/copilot.lua",
    "https://github.com/NickvanDyke/opencode.nvim",
})

-- TODO: sign up hook and add instructions to copilot.lua? No login hook better
require("copilot").setup({
    panel = { enabled = false },
    suggestion = {
        auto_trigger = false,
        hide_during_completion = false,
        debounce = 0,
        keymap = { accept = "<C-d>" },
    },
    filetypes = {
        ["*"] = true,
    },
})

vim.o.autoread = true

vim.g.opencode_opts = {
    events = {
        permissions = { enabled = false },
    },
    server = {
        start = function()
            require("snacks.terminal").open("opencode --port", { win = { position = "float", enter = true } })
        end,
        stop = function()
            require("snacks.terminal").get("opencode --port", { win = { position = "float" } }):close()
        end,
        toggle = function()
            require("snacks.terminal").toggle("opencode --port", { win = { position = "float", enter = true } })
        end,
    },
}

vim.keymap.set({ "n", "x" }, "<leader>ap", function()
    require("opencode").select()
end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "x" }, "<leader>ao", function()
    require("opencode").prompt("@this")
end, { desc = "Add to opencode" })
vim.keymap.set({ "n", "t" }, "<c-a>", function()
    require("opencode").toggle()
end, { desc = "Toggle opencode" })
