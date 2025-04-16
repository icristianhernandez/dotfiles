if not vim.g.neovide then
    return
end

local centered_padding = 1
local scale_delta = 0.1

vim.o.guifont = "JetBrainsMonoNL Nerd Font:h14"

if vim.g.neovide then
    vim.g.snacks_animate = false
end

vim.g.neovide_cursor_antialiasing = true
vim.opt.linespace = 0
vim.g.neovide_refresh_rate = 120
vim.g.neovide_fullscreen = true
-- vim.g.neovide_underline_stroke_scale = 3
vim.g.neovide_cursor_smooth_blink = true
vim.g.neovide_padding_right = centered_padding
vim.g.neovide_padding_left = centered_padding
vim.g.neovide_scroll_animation_far_lines = 0
-- vim.g.neovide_scroll_animation_length = 0

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
    change_scale_factor(1 + scale_delta)
end)
vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / (1 + scale_delta))
end)
vim.keymap.set("n", "<C-'>", function()
    vim.g.neovide_scale_factor = 1
end)
