vim.pack.add({
    "https://github.com/MagicDuck/grug-far.nvim",
})

require("grug-far").setup({
    windowCreationCommand = "tab split",
    folding = { enabled = false },

    -- helpLine = {
    --     enabled = false,
    -- },
    showCompactInputs = true,
    -- showInputsTopPadding = false,
    -- showInputsBottomPadding = false,
    -- showEngineInfo = false,

    openTargetWindow = {
        preferredLocation = "right",
    },

    keymaps = {
        nextInput = { n = "<tab>", i = "<cr>" },
        prevInput = { n = "<s-tab>", i = "<s-tab>" },
        help = "g?",
        qflist = "<c-q>",
        syncLocations = { n = "<c-s>" },
        -- NOTES: the three following keymaps can be useful...
        syncNext = false,
        syncPrev = false,
        syncFile = false,
        replace = false,
        syncLine = false,
        close = false,
        historyOpen = false,
        historyAdd = false,
        refresh = false,
        openLocation = false,
        openNextLocation = false,
        openPrevLocation = false,
        gotoLocation = false,
        pickHistoryEntry = false,
        abort = false,
        toggleShowCommand = false,
        swapEngine = false,
        previewLocation = false,
        swapReplacementInterpreter = false,
        applyNext = false,
        applyPrev = false,
    },
})

vim.keymap.set({ "n", "x" }, "<leader>sf", function()
    require("grug-far").open({ prefills = { paths = vim.fn.expand("%:p"), flags = "-F" } })
end, { desc = "Grug Far (current file)" })

vim.keymap.set({ "n", "x" }, "<leader>sF", function()
    require("grug-far").open({ prefills = { flags = "-F" } })
end, { desc = "Grug Far (pwd)" })
