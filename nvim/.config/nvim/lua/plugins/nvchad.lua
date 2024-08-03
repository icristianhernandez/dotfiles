vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"

return {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
        -- ui highlights
        for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
            dofile(vim.g.base46_cache .. v)
        end

        -- nvchad modules
        require "nvchad.options"
        require "nvchad.autocmds"
        require "nvchad.mappings"
    end,
}
