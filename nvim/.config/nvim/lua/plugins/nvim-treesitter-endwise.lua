return {
    -- Automatically add `end` to blocks in Lua and other lenguajes
    "RRethy/nvim-treesitter-endwise",
    event = { "InsertEnter" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
}
