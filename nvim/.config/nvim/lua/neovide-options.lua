-- neovide check
if not vim.g.neovide then
    return
end

-- font settings
vim.o.guifont = "JetBrainsMonoNL Nerd Font:h14"

-- neovide settings
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_cursor_antialiasing = true
vim.opt.linespace = -1
