return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ':TSUpdate'
    },
    {
        'MeanderingProgrammer/treesitter-modules.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        ---@module 'treesitter-modules'
        ---@type ts.mod.UserConfig
        opts = {
            ensure_installed = {},
            auto_install = true,

            highlight = {
                enable = true,
            },

            indent = {
                enable = true,
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<cr>',
                    node_incremental = '<cr>',
                    scope_incremental = false,
                    node_decremental = '<bs>',
                },
            },
        },
    },
}
