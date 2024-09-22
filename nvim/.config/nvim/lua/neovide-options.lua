-- neovide check
if not vim.g.neovide then
    return
end

-- font settings
vim.o.guifont = "JetBrainsMonoNL Nerd Font:h13"

-- neovide settings
-- vim.g.neovide_cursor_antialiasing = true
-- vim.opt.linespace = -1
-- vim.g.neovide_refresh_rate = 120

-- if neovide open in exe directory, change to a desired initial directory
local desired_initial_dir = "~/"
local neovide_exe_path = "/mnt/c/Program Files/Neovide"
if vim.fn.getcwd() == neovide_exe_path then
    vim.cmd("cd " .. desired_initial_dir)
end

---- neovide keymaps
-- toggle fullscreen
vim.api.nvim_set_keymap(
    "n",
    "<F11>",
    ":lua vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen<CR>",
    { noremap = true, silent = true }
)

-- change font scale
local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

vim.keymap.set("n", "<C-+>", function()
    change_scale_factor(1.25)
end)
vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
end)
