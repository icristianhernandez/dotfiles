-- MISSING:
-- 1. Blink (now in snacks.lua via 00-snacks.lua)
-- 2. Additional snacks integrations below
vim.pack.add({
    "https://github.com/tpope/vim-sleuth",
    "https://github.com/stevearc/quicker.nvim",
    "https://github.com/cbochs/grapple.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/chrisgrieser/nvim-recorder",
})

require("quicker").setup()

vim.keymap.set({ "n", "x" }, "<leader>H", function()
    require("grapple").toggle()
end, { desc = "Tag a file" })

vim.keymap.set({ "n", "x" }, "<leader>h", function()
    require("grapple").toggle_tags()
end, { desc = "Toggle Grapple tags window" })

for i = 1, 9 do
    vim.keymap.set({ "n", "x" }, "<leader>" .. i, function()
        require("grapple").select({ index = i })
    end, { desc = "Select grapple tag " .. i })
    vim.keymap.set({ "n", "x" }, "s" .. i, function()
        require("grapple").tag({ index = i })
    end, { desc = "Save to grapple slot " .. i })
end

require("grapple").setup({
    scope = "git_branch",
})

require("mini.cmdline").setup({
    autopeek = {
        n_context = 3,
    },
})

require("which-key").setup({
    preset = "helix",
    spec = {
        {
            mode = { "n", "x" },
            { "<leader><tab>", group = "tabs" },
            { "<leader>d", group = "debug" },
            { "<leader>f", group = "file/find" },
            { "<leader>g", group = "git" },
            { "<leader>q", group = "quit/session" },
            { "<leader>s", group = "search" },
            { "<leader>u", group = "ui" },
            { "<leader>x", group = "diagnostics/quickfix" },
            { "<leader>a", group = "ai" },
            { "<leader>c", group = "code" },
            { "<leader>t", group = "tasks" },
            { "[", group = "prev" },
            { "]", group = "next" },
            { "g", group = "goto" },
            { "z", group = "fold" },
            {
                "<leader>w",
                group = "windows",
                proxy = "<c-w>",
                expand = function()
                    return require("which-key.extras").expand.win()
                end,
            },
        },
    },
})

local group = vim.api.nvim_create_augroup("MiniFilesExtras", { clear = true })

vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MiniFilesWindowUpdate",

    callback = function(args)
        local win_id = args and args.data and args.data.win_id
        if not win_id then
            return
        end
        local h = math.max(math.floor(vim.o.lines * 0.20), 14)
        local cfg = vim.api.nvim_win_get_config(win_id)
        cfg.height = h
        vim.api.nvim_win_set_config(win_id, cfg)
    end,
})

vim.keymap.set({ "n", "x" }, "<leader>e", "", { desc = "+file explorer" })

vim.keymap.set({ "n", "x" }, "<leader>ee", function()
    local MiniFiles = require("mini.files")
    local current_file = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(current_file, false)
    MiniFiles.reveal_cwd()
end, { desc = "Open mini.files (Directory of Current File)" })

vim.keymap.set({ "n", "x" }, "<leader>ec", function()
    require("mini.files").open(vim.fn.getcwd(), true)
end, { desc = "Open mini.files (CWD, With Saving State)" })

vim.keymap.set({ "n", "x" }, "<leader>eC", function()
    require("mini.files").open(vim.fn.getcwd(), false)
end, { desc = "Open mini.files (CWD, Without Saving State)" })

require("mini.files").setup({
    options = { use_as_default_explorer = true },
    windows = {
        max_number = 3,
        preview = true,
        width_focus = 35,
        width_preview = 60,
    },
    mappings = {
        go_in = "L",
        go_in_plus = "l",
        go_out = "H",
        go_out_plus = "h",
    },
})

require("recorder").setup({})
