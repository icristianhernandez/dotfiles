return {
    -- disable highlights of not actual windows in the tab
    "tadaa/vimade",
    lazy = true,
    event = "VeryLazy",

    opts = function(_, opts)
        Snacks.toggle({
            name = "Vimade",
            get = function()
                return true
            end,
            set = function()
                vim.cmd("VimadeToggle")
            end,
        }):map("<leader>uv")

        local my_opts = {
            recipe = { "default", { animate = false } },
        }

        return vim.tbl_extend("force", opts or {}, my_opts)
    end,
}
