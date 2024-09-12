-- neovide check
if not vim.g.neovide then
    return
end

-- font settings
vim.o.guifont = "JetBrainsMonoNL Nerd Font:h14"

-- neovide settings
vim.g.neovide_cursor_antialiasing = true
