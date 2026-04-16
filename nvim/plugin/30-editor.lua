vim.pack.add({
    "https://github.com/rmagatti/auto-session",
    "https://github.com/echasnovski/mini.files",
    "https://github.com/nvim-mini/mini.cmdline",
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/onsails/lspkind.nvim",
    "https://github.com/saghen/blink.cmp",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/cbochs/grapple.nvim",
    "https://github.com/stevearc/quicker.nvim",
    "https://github.com/folke/flash.nvim",
    "https://github.com/m4xshen/hardtime.nvim",
    "https://github.com/mrjones2014/smart-splits.nvim",
    "https://github.com/tpope/vim-sleuth",
})

-- auto-session
vim.o.sessionoptions = "blank,buffers,folds,curdir,help,tabpages,terminal,localoptions"
require("auto-session").setup({
    git_use_branch_name = true,
    git_auto_restore_on_branch_change = true,
    cwd_change_handling = true,
    auto_restore_last_session = vim.fn.getcwd() == vim.fn.expand("~")
        and vim.fn.argc() == 0
        and (#vim.api.nvim_list_uis() > 0),
    continue_restore_on_error = true,
})
vim.keymap.set("n", "<leader>ss", "<cmd>AutoSession search<CR>", { noremap = true, desc = "Search session" })
vim.keymap.set("n", "<leader>sS", "<cmd>AutoSession deletePicker<CR>", { noremap = true, desc = "Delete sessions" })

-- mini.files
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

local mf_group = vim.api.nvim_create_augroup("MiniFilesExtras", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = mf_group,
    pattern = "MiniFilesWindowUpdate",
    callback = function(args)
        local win_id = args and args.data and args.data.win_id
        if not win_id then return end
        local h = math.max(math.floor(vim.o.lines * 0.20), 14)
        local cfg = vim.api.nvim_win_get_config(win_id)
        cfg.height = h
        vim.api.nvim_win_set_config(win_id, cfg)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesActionRename",
    callback = function(event)
        require("snacks").rename.on_rename_file(event.data.from, event.data.to)
    end,
})

local MiniFiles = require("mini.files")
local orig_close = MiniFiles.close
---@diagnostic disable-next-line: duplicate-set-field
MiniFiles.close = function(...)
    local ft = vim.bo.filetype or ""
    local function is_ignored_ft(ft_to_check)
        return ft_to_check == "TelescopePrompt" or ft_to_check == "noice" or ft_to_check:match("^snacks")
    end
    local function current_win_is_floating()
        local ok, cfg = pcall(vim.api.nvim_win_get_config, 0)
        return ok and cfg and cfg.relative and cfg.relative ~= ""
    end
    if is_ignored_ft(ft) and current_win_is_floating() then
        return false
    end
    return orig_close(...)
end

vim.keymap.set("n", "<leader>ee", function()
    local current_file = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(current_file, false)
    MiniFiles.reveal_cwd()
end, { desc = "Open mini.files (Directory of Current File)" })
vim.keymap.set("n", "<leader>ec", function()
    require("mini.files").open(vim.fn.getcwd(), true)
end, { desc = "Open mini.files (CWD, Save State)" })
vim.keymap.set("n", "<leader>eC", function()
    require("mini.files").open(vim.fn.getcwd(), false)
end, { desc = "Open mini.files (CWD, Without State)" })

-- mini.cmdline
require("mini.cmdline").setup({
    autopeek = { n_context = 3 },
})

-- blink.cmp
require("luasnip").setup({
    loaders_store_source = false,
    update_events = { "InsertLeave", "TextChangedI" },
    history = true,
    delete_check_events = "TextChanged",
})
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({
    paths = { vim.fn.stdpath("config") .. "/snippets" },
})

require("lspkind").init({ preset = "default" })

vim.keymap.set("s", "<BS>", "<C-O>s")
require("blink.cmp").setup({
    snippets = { preset = "luasnip" },
    keymap = {
        preset = "none",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-e>"] = { "show", "hide", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },
    signature = {
        enabled = true,
        trigger = { show_on_keyword = true, show_on_insert = true },
    },
    completion = {
        menu = {
            auto_show_delay_ms = 0,
            max_height = 8,
            draw = {
                columns = { { "label", "label_description", gap = 1 }, { "kind_icon", gap = 1, "kind" } },
                components = {
                    kind_icon = {
                        text = function(ctx)
                            return require("lspkind").symbolic(ctx.kind, { mode = "symbol" }) .. ctx.icon_gap
                        end,
                    },
                },
            },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 10 },
        list = { selection = { preselect = false, auto_insert = false } },
        keyword = { range = "full" },
        ghost_text = { enabled = true },
        trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_backspace = true,
            show_on_insert = true,
            show_on_trigger_character = true,
            show_on_accept_on_trigger_character = true,
            show_on_insert_on_trigger_character = true,
        },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
            lsp = {
                name = "LSP",
                module = "blink.cmp.sources.lsp",
                transform_items = function(_, items)
                    local kinds = require("blink.cmp.types").CompletionItemKind
                    return vim.tbl_filter(function(item) return item.kind ~= kinds.Snippet end, items)
                end,
                override = {
                    get_trigger_characters = function(self)
                        local trigger_characters = self:get_trigger_characters()
                        vim.list_extend(trigger_characters, { "\n", "\t", " ", "-" })
                        return trigger_characters
                    end,
                },
            },
        },
    },
    cmdline = { enabled = false },
})

-- gitsigns.nvim
require("gitsigns").setup({
    signs_staged = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
    signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
    },
})

-- which-key.nvim
require("which-key").setup({
    preset = "helix",
    spec = {
        {
            mode = { "n", "x" },
            { "<leader><tab>", group = "tabs" },
            { "<leader>d", group = "debug" },
            { "<leader>f", group = "file/find" },
            { "<leader>g", group = "git" },
            { "<leader>gh", group = "hunks" },
            { "<leader>q", group = "quit/session" },
            { "<leader>s", group = "search" },
            { "<leader>u", group = "ui" },
            { "<leader>x", group = "diagnostics/quickfix" },
            { "<leader>a", group = "ai" },
            { "<leader>c", group = "code" },
            { "[", group = "prev" },
            { "]", group = "next" },
            { "g", group = "goto" },
            { "z", group = "fold" },
            {
                "<leader>w",
                group = "windows",
                proxy = "<c-w>",
                expand = function() return require("which-key.extras").expand.win() end,
            },
        },
    },
})
vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer Local Keymaps (which-key)" })

-- grapple.nvim
require("grapple").setup({ scope = "git_branch" })
vim.keymap.set("n", "<leader>H", function() require("grapple").toggle() end, { desc = "Tag a file" })
vim.keymap.set("n", "<leader>h", function() require("grapple").toggle_tags() end, { desc = "Toggle Grapple tags window" })
for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function() require("grapple").select({ index = i }) end, { desc = "Select grapple tag " .. i })
end

-- quicker.nvim
require("quicker").setup({
    keys = {
        { ">", function() require("quicker").expand({ before = 1, after = 2, add_to_existing = true }) end, desc = "Expand quickfix context" },
        { "<", function() require("quicker").collapse() end, desc = "Collapse quickfix context" },
    },
})

-- flash.nvim
require("flash").setup({
    labels = "qwertasdfgzxcvb",
    modes = {
        char = {
            char_actions = function() return { [";"] = "next", ["f"] = "right", ["F"] = "left" } end,
            enabled = true,
            keys = { "f", "F", "t", "T", ";" },
            jump_labels = false,
            multi_line = true,
        },
    },
    prompt = { win_config = { border = "none" } },
    search = { wrap = true },
    label = { rainbow = { enabled = true, shade = 1 } },
})
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "o", "x" }, "S", function() require("flash").treesitter_search() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })

-- hardtime.nvim
require("hardtime").setup({
    disable_mouse = false,
    restricted_keys = { ["k"] = false, ["j"] = false },
    disabled_keys = { ["<Up>"] = false, ["<Down>"] = false, ["<Left>"] = false, ["<Right>"] = false },
})

-- smart-splits.nvim
require("smart-splits").setup({})
vim.keymap.set("n", "<Up>", "<cmd>lua require('smart-splits').resize_up()<CR>", { noremap = true, silent = true, desc = "Resize split up" })
vim.keymap.set("n", "<Down>", "<cmd>lua require('smart-splits').resize_down()<CR>", { noremap = true, silent = true, desc = "Resize split down" })
vim.keymap.set("n", "<Left>", "<cmd>lua require('smart-splits').resize_left()<CR>", { noremap = true, silent = true, desc = "Resize split left" })
vim.keymap.set("n", "<Right>", "<cmd>lua require('smart-splits').resize_right()<CR>", { noremap = true, silent = true, desc = "Resize split right" })

-- vim-sleuth
-- (Sourced automatically)
