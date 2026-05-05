-- MISSING:
-- 2. Lualine or something related to the statusline
-- 4. Notifications (ui2 enough?)
-- 5. Cmdline at the top-center of the screen

vim.pack.add({
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/saghen/blink.indent",
    "https://github.com/HiPhish/rainbow-delimiters.nvim",
    "https://github.com/catgoose/nvim-colorizer.lua",
    "https://github.com/nvimdev/hlsearch.nvim",
    "https://github.com/OXY2DEV/helpview.nvim",
    "https://github.com/sphamba/smear-cursor.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/shortcuts/no-neck-pain.nvim",

    --
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/smjonas/inc-rename.nvim",
})

require("lualine").setup({
    options = {
        always_show_tabline = false,
        -- component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    tabline = {
        lualine_b = {
            { "tabs", mode = 2, max_length = vim.o.columns },
        },
    },
})

require("blink.indent").setup({
    static = {
        -- char = "▏",
    },
    scope = {
        enabled = false,
        -- char = "▏",
        -- underline = { enabled = true },
    },
})

require("colorizer").setup()

require("hlsearch").setup()

require("helpview").setup()

require("smear_cursor").setup({
    -- never_draw_over_target = false

    -- without smear
    stiffness = 0.5,
    trailing_stiffness = 0.5,
    matrix_pixel_threshold = 0.5,
})

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
vim.schedule(MiniIcons.tweak_lsp_kind)
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = require("mini.icons").get("lsp", "error"),
            [vim.diagnostic.severity.WARN] = require("mini.icons").get("lsp", "warn"),
            [vim.diagnostic.severity.INFO] = require("mini.icons").get("lsp", "info"),
            [vim.diagnostic.severity.HINT] = require("mini.icons").get("lsp", "hint"),
        },
    },
})
require("mini.trailspace").setup()

require("mini.diff").setup()

vim.keymap.set("n", "<leader>gh", function()
    vim.fn.setqflist(MiniDiff.export("qf"))
end, { desc = "Hunks quickfix" })

require("no-neck-pain").setup({
    width = 98,
    buffers = {
        wo = { sidescrolloff = 0 },
        left = { wo = { sidescrolloff = 0 } },
        right = { wo = { sidescrolloff = 0 } },
    },
    autocmds = {
        -- enableOnVimEnter = true,
        -- enableOnTabEnter = true,
        reloadOnColorSchemeChange = true,
        -- BUG: the vsplits used for padding enlarges when skipped by:
        skipEnteringNoNeckPainBuffer = true,
    },
    mappings = {
        enabled = true,
        toggle = "<leader>un",
        toggleLeftSide = false,
        toggleRightSide = false,
        widthUp = false,
        widthDown = false,
        scratchPad = false,
    },
})

require("inc_rename").setup({})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user.lsp", {}),
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client:supports_method("textDocument/rename") then
            vim.keymap.set("n", "grn", ":IncRename ", { buffer = bufnr, desc = "IncRename (LSP)" })
        end
    end,
})
