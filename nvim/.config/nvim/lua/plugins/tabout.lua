return {
    -- To exit actual context in insert mode. Testing how good it is
    "abecodes/tabout.nvim",
    lazy = false,
    event = "InsertCharPre",

    opts = function(_, opts)
        vim.keymap.set({ "i", "n" }, "<c-x>", "<Plug>(TaboutMulti)", { silent = true })
        vim.keymap.set({ "i", "n" }, "<c-z>", "<Plug>(TaboutBackMulti)", { silent = true })

        local my_opts = {
            tabkey = "",
            backwards_tabkey = "",
            act_as_tab = false,
        }

        return vim.tbl_extend("force", opts or {}, my_opts)
    end,
}
