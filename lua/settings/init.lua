require('settings.options')

-- Themes
require('themes.material')
require('themes.dracula')
require('themes.tokyonight')
require('themes.onedark')
vim.cmd[[colorscheme dracula]]

-- Plugins:
require('plugins.packer')
require('plugins.treesitter')
require('plugins.lualine')
require('plugins.indent-blankline')
require('plugins.autopairs')
