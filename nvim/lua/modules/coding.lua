return {
    {
        -- saghen/blink.pairs: fast and configurable autopairs plugin
        "saghen/blink.pairs",
        -- (recommended) only required with prebuilt binaries
        version = "*",
        dependencies = "saghen/blink.download",

        --- @module 'blink.pairs'
        --- @type blink.pairs.Config
        opts = {
            mappings = {
                -- you can call require("blink.pairs.mappings").enable()
                -- and require("blink.pairs.mappings").disable()
                -- to enable/disable mappings at runtime
                enabled = true,
                cmdline = true,
                -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
                -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
                disabled_filetypes = {},
            },
            highlights = {
                enabled = true,
                -- requires require('vim._extui').enable({}), otherwise has no effect
                cmdline = true,

                matchparen = {
                    enabled = true,
                    cmdline = true,
                    include_surrounding = true,
                },
            },
        },
        config = function(_, opts)
            local ok, extui = pcall(require, "vim._extui")
            if ok and type(extui.enable) == "function" then
                extui.enable({})
            elseif opts and opts.highlights and opts.highlights.enabled then
                opts.highlights.enabled = false
            end

            require("blink.pairs").setup(opts)
        end,
    },
    {
        -- RRethy/nvim-treesitter-endwise: auto add 'end' in end-style block languages
        "RRethy/nvim-treesitter-endwise",
        event = { "InsertEnter" },
        -- nvim-treesitter/nvim-treesitter: incremental parsing and AST-based features
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        -- windwp/nvim-ts-autotag: auto-close and rename HTML/JSX tags using Treesitter
        "windwp/nvim-ts-autotag",
        event = { "InsertEnter" },
        -- nvim-treesitter/nvim-treesitter: incremental parsing and AST-based features
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {},
    },
    {
        -- echasnovski/mini.move: move lines, blocks and selections easily
        "echasnovski/mini.move",
        event = "VeryLazy",
        opts = {
            mappings = {
                left = "<S-h>",
                right = "<S-l>",
                down = "<S-j>",
                up = "<S-k>",
            },
        },
    },
    {
        -- splitjoin: split or join arguments in/of different lines
        "echasnovski/mini.splitjoin",
        lazy = true,

        keys = {
            { "gs" },
        },

        opts = {
            mappings = {
                toggle = "gs",
            },
        },
    },

    {
        -- kylechui/nvim-surround: add/change/delete surrounding delimiters (quotes, brackets)
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {
            keymaps = { visual = "ñ" },
        },
        config = function()
            require("nvim-surround").setup({ keymaps = { visual = "ñ" } })
        end,
    },

    {
        -- folke/ts-comments.nvim: toggle and manage comments using Treesitter
        "folke/ts-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        -- better code folding, lsp integration with ts->indent fallback and better aesthethics
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        config = function()
            vim.o.foldcolumn = "0" -- '0' is not bad
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
            vim.keymap.set("n", "zR", require("ufo").openAllFolds)
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

            -- -- Use lsp for folds
            -- vim.lsp.config("*", {
            --     capabilities = {
            --         textDocument = {
            --             foldingRange = {
            --                 dynamicRegistration = false,
            --                 lineFoldingOnly = true,
            --             },
            --         },
            --     },
            -- })
            -- require("ufo").setup()

            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end,
            })
        end,
    },
}
