return {
    -- To exit actual context in insert mode. Testing how good it is
    "abecodes/tabout.nvim",
    lazy = true,

    keys = {
        { "<c-x>", "<Plug>(TaboutMulti)", mode = { "i", "n" }, silent = true },
        { "<c-z>", "<Plug>(TaboutBackMulti)", mode = { "i", "n" }, silent = true },
    },

    opts = {
        tabkey = "",
        backwards_tabkey = "",
        act_as_tab = false,
    },
}
