vim.pack.add({
    "https://github.com/sphamba/smear-cursor.nvim",
    "https://github.com/shortcuts/no-neck-pain.nvim",
    "https://github.com/nvim-pack/nvim-spectre",
    "https://github.com/chrisgrieser/nvim-recorder",
    "https://github.com/stevearc/overseer.nvim",
    "https://github.com/sustech-data/wildfire.nvim",
    "https://github.com/MeanderingProgrammer/treesitter-modules.nvim",
    "https://github.com/kristijanhusak/vim-dadbod-ui",
    "https://github.com/tpope/vim-dadbod",
})

-- smear-cursor.nvim
if vim.g.neovide == nil then
    require("smear-cursor").setup({})
end

-- no-neck-pain.nvim
require("no-neck-pain").setup({
    width = 98,
    buffers = {
        wo = { sidescrolloff = 0 },
        left = { wo = { sidescrolloff = 0 } },
        right = { wo = { sidescrolloff = 0 } },
    },
    autocmds = {
        reloadOnColorSchemeChange = true,
        skipEnteringNoNeckPainBuffer = true,
    },
    mappings = { enabled = false },
})
vim.keymap.set("n", "<leader>un", function() require("no-neck-pain").toggle() end, { desc = "Toggle NoNeckPain" })

-- nvim-spectre
require("spectre").setup({
    open_cmd = function()
        local buf = vim.api.nvim_create_buf(false, true)
        local width = math.max(60, math.floor(vim.o.columns * 0.85))
        local height = math.max(10, math.floor(vim.o.lines * 0.6))
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)
        vim.api.nvim_open_win(buf, true, {
            relative = "editor", width = width, height = height,
            row = row, col = col, style = "minimal", border = "rounded",
        })
    end,
    mapping = {
        close = { map = "q", cmd = "<cmd>lua require('spectre').close()<CR>", desc = "Close Spectre" },
    },
    default = { find = { options = { "ignore-case" } } },
})
vim.keymap.set("n", "<leader>sf", function() require("spectre").toggle() end, { desc = "Toggle Spectre" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, { desc = "Spectre: Search current word" })
vim.keymap.set({ "n", "x" }, "<leader>sp", function() require("spectre").open_file_search({ select_word = false }) end, { desc = "Spectre: Search in current file" })

-- nvim-recorder
require("nvim-recorder").setup({})

-- overseer.nvim
local dotfiles_root = vim.fn.expand("~") .. "/dotfiles"
local script_name = "git-auto-commit-opencode.sh"
local script_path = (vim.fs and vim.fs.joinpath(dotfiles_root, "scripts", script_name))
    or (dotfiles_root .. "/scripts/" .. script_name)

local overseer = require("overseer")
overseer.register_template({
    name = "Auto commit with OpenCode",
    builder = function()
        local cwd = vim.fn.getcwd()
        return { cmd = { "bash", script_path }, cwd = cwd, name = "auto-commit-opencode" }
    end,
})
if vim.fn.filereadable(script_path) == 0 then
    vim.notify(string.format("overseer: script not found at %s", script_path), vim.log.levels.WARN)
end

require("overseer").setup({})
local template = require("overseer.template")
local original_list = template.list
template.list = function(search_opts, callback)
    return original_list(search_opts, function(templates)
        templates = vim.tbl_filter(function(tmpl) return not tmpl.hide end, templates)
        if #templates == 1 then
            table.insert(templates, {
                name = "Cancel", desc = "Do not run any task",
                builder = function() return { cmd = "true", args = {}, name = "Cancelled", components = { "on_complete_dispose" } } end,
            })
        end
        return callback(templates)
    end)
end
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("overseer_task_float", { clear = true }),
    callback = function(args)
        if vim.b[args.buf].overseer_task then
            vim.keymap.set("n", "q", function() vim.api.nvim_win_close(0, false) end, { buffer = args.buf, silent = true, desc = "Close task output window" })
        end
    end,
})
vim.keymap.set("n", "<leader>ac", function()
    vim.notify("overseer: starting auto-commit task", vim.log.levels.INFO)
    require("overseer").run_task({ name = "Auto commit with OpenCode" })
end, { desc = "Run auto-commit script" })
vim.keymap.set("n", "<leader>tt", function() require("overseer").toggle() end, { desc = "Toggle Overseer task running list" })
vim.keymap.set("n", "<leader>tr", function() require("overseer").run_task({ first = false }) end, { desc = "Show available tasks (no auto-run)" })

-- wildfire.nvim
require("wildfire").setup({ surrounds = {} })

-- treesitter-modules.nvim
local tooling = require("modules.extras.tooling").tooling
require("treesitter-modules").setup({
    ensure_installed = tooling.treesitter.ensure_installed,
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
})

-- vim-dadbod-ui
vim.g.db_ui_use_nerd_fonts = 1
vim.g.dbs = {
    { name = "supabase-local", url = "postgresql://postgres:postgres@127.0.0.1:54322/postgres?sslmode=disable" },
}
vim.keymap.set("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Toggle Database UI" })
