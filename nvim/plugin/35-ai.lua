-- AI Plugin Initializations (after snacks is initialized in 00-libs.lua)
-- copilot.lua
require("copilot").setup({
    panel = { enabled = false },
    suggestion = {
        auto_trigger = false,
        hide_during_completion = false,
        debounce = 0,
        keymap = { accept = "<C-d>" },
    },
    filetypes = { ["*"] = true },
})

-- opencode.nvim
vim.o.autoread = true
local opencode_cmd = "opencode --port"
local snacks_terminal_opts = { win = { position = "float", enter = true } }

vim.g.opencode_opts = {
    events = { permissions = { enabled = false } },
    server = {
        start = function() require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts) end,
        stop = function() require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts):close() end,
        toggle = function() require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts) end,
    },
}

vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
vim.keymap.set({ "n", "x" }, "<leader>ap", function() require("opencode").select() end, { desc = "Execute opencode action…" })
vim.keymap.set({ "n", "x" }, "<leader>ao", function() require("opencode").prompt("@this") end, { desc = "Add to opencode" })
vim.keymap.set({ "n", "t" }, "<c-a>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
vim.keymap.set("n", "<leader>au", function() require("opencode").command("session.half.page.up") end, { desc = "opencode half page up" })
vim.keymap.set("n", "<leader>ad", function() require("opencode").command("session.half.page.down") end, { desc = "opencode half page down" })
