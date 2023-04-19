-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Themes
  use 'Mofiqul/dracula.nvim' 
  use 'folke/tokyonight.nvim'
  use 'marko-cerovac/material.nvim'
  use 'navarasu/onedark.nvim'
  

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- lualine (statusline)
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- indent-blankline (dipslay a indent visual guide to all lines)
  use "lukas-reineke/indent-blankline.nvim"
    
  -- nvim-tree, files manager
  use {
  'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons', -- optional
  },
  config = function()
    require("nvim-tree").setup {}
  end
  }

  -- Autopairs (for automatic completations of () [] {}, etc)
use {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
}
  
end)
