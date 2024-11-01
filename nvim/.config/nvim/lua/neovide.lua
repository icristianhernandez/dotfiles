-- neovide check
if not vim.g.neovide then
    return
end

-- font settings
vim.o.guifont = "JetBrainsMonoNL Nerd Font:h14"

-- neovide settings
vim.g.neovide_cursor_antialiasing = true
vim.opt.linespace = -1
vim.g.neovide_refresh_rate = 60
-- vim.g.neovide_transparency = 0.95
vim.g.neovide_fullscreen = true

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

local scale_delta = 0.1
vim.keymap.set("n", "<C-+>", function()
    change_scale_factor(1 + scale_delta)
end)
vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / (1 + scale_delta))
end)
vim.keymap.set("n", "<C-'>", function()
    vim.g.neovide_scale_factor = 1
end)

vim.g.neovide_scroll_animation_far_lines = 0
-- vim.g.neovide_scroll_animation_length = 0
