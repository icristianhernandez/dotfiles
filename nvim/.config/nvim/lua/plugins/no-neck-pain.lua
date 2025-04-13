return {
    -- no-neck-pain: center the buffer
    "shortcuts/no-neck-pain.nvim",
    event = "BufReadPre",

    opts = function(_, opts)
        local enabled = true
        Snacks.toggle({
            name = "No Neck Pain",

            get = function()
                return enabled
            end,

            set = function(state)
                if state ~= enabled then
                    enabled = state
                    require("no-neck-pain").toggle()
                end
            end,
        }):map("<leader>uN")

        local my_opts = {
            width = 90,
            autocmds = {
                enableOnVimEnter = true,
                enableOnTabEnter = true,
            },
        }

        return vim.tbl_extend("force", opts or {}, my_opts)
    end,
}
