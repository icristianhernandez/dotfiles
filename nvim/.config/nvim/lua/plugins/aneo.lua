return {
    "amanbabuhemant/aneo.nvim",
    config = function()
        require("aneo").setup()
        -- vim.defer_fn(function()
        --     vim.cmd("Aneo mini-2b")
        -- end, 0)
    end,
}
