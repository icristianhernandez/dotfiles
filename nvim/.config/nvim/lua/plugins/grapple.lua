-- immediate navigation to important files
---@type LazySpec
return {
    "cbochs/grapple.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", lazy = true },
    },

    -- event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",

    ---@module "grapple"
    ---@type grapple.settings
    opts = {
        scope = "git_branch", -- can try 'git' if that's not great
        icons = true,
    },

    keys = {
        { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
        { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
        { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
        { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },
        { "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "Select fourth tag" },

        -- add file and menu
        { "<leader>mm", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle tag" },
        { "<leader>ml", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
        { "<leader>mr", "<cmd>Grapple reset<cr>", desc = "Grapple refresh tags" },

        -- add in index 1-4
        { "<leader>m1", "<cmd>Grapple tag index=1<cr>", desc = "Grapple tag index 1" },
        { "<leader>m2", "<cmd>Grapple tag index=2<cr>", desc = "Grapple tag index 2" },
        { "<leader>m3", "<cmd>Grapple tag index=3<cr>", desc = "Grapple tag index 3" },
        { "<leader>m4", "<cmd>Grapple tag index=4<cr>", desc = "Grapple tag index 4" },
        { "<leader>m5", "<cmd>Grapple tag index=5<cr>", desc = "Grapple tag index 5" },
    },

    config = function(_, opts)
        -- setup grapple
        require("grapple").setup(opts)

        vim.api.nvim_create_autocmd("SessionLoadPost", {
            pattern = "*",
            callback = function()
                vim.cmd("Grapple clear_cache")
            end,
        })
    end,
}
