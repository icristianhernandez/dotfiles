-- to configure nvim native options
vim.opt.colorcolumn = "80"

-- Copilot - Autocomplete
vim.g.copilot_node_command = "/home/crlinux/.nvm/versions/node/v18.16.0/bin/node"
vim.api.nvim_set_keymap("i", "<C-i>", 'copilot#Accept("")', { silent = true, expr = true })
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = {
    markdown = true,
}

-- [[ Ident - Whitespace ]]
-- vim.opt.expandtab = true             -- bool: Use spaces instead of tabs
vim.opt.shiftwidth = 4               -- num:  Size of an indent
vim.opt.softtabstop = 4              -- num:  Number of spaces tabs count for in insert mode
vim.opt.tabstop = 4                  -- num:  Number of spaces tabs count for
