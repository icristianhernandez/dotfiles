-- disable highlights of not actual windows in the tab
return {
    "tadaa/vimade",
    opts = function(opts)
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
            recipe = { "default", { animate = true } },
        }
        -- trying to merge the tables crash with a strange recursion bug
        return my_opts
    end,
}
