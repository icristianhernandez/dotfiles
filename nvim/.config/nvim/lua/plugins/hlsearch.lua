return {
    -- remove highlight search after movement outside the search
    "nvimdev/hlsearch.nvim",
    event = "BufRead",
    config = function()
        require("hlsearch").setup()
    end,
}
