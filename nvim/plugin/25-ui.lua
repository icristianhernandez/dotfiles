vim.pack.add({
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/AndreM222/copilot-lualine",
    "https://github.com/saghen/blink.indent",
    "https://github.com/HiPhish/rainbow-delimiters.nvim",
    "https://github.com/folke/noice.nvim",
    "https://github.com/smjonas/inc-rename.nvim",
    "https://github.com/catgoose/nvim-colorizer.lua",
    "https://github.com/OXY2DEV/helpview.nvim",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    "https://github.com/nvimdev/hlsearch.nvim",
})

-- lualine.nvim
local lualine_ok, cache = pcall(require, "modules.extras.lualine_cache")
if lualine_ok and cache and type(cache.setup) == "function" then
    pcall(cache.setup)
end
require("lualine").setup({
    options = {
        always_show_tabline = false,
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = { { "filename", path = 4 } },
        lualine_b = { { function() return vim.b.lualine_cached_parent_path or "" end } },
        lualine_c = {},
        lualine_x = { "copilot", "progress" },
        lualine_y = { "diff", "diagnostics" },
        lualine_z = { { "datetime", style = "%H:%M" } },
    },
    tabline = {
        lualine_b = { { "tabs", mode = 2, max_length = vim.o.columns } },
    },
})

-- blink.indent
require("blink.indent").setup({
    scope = { enabled = false },
})

-- noice.nvim
require("noice").setup({
    lsp = {
        signature = { enabled = false },
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
        },
    },
    presets = {
        bottom_search = true,
        command_palette = true,
        inc_rename = true,
    },
    cmdline = {
        format = { filter = false, lua = false, help = false },
    },
    views = {
        cmdline_popup = { border = { style = "single", padding = { 0, 2 } } },
    },
})

-- inc-rename.nvim
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

-- nvim-colorizer.lua
require("colorizer").setup({})

-- helpview.nvim
require("helpview").setup({})

-- render-markdown.nvim
require("render-markdown").setup({})

-- hlsearch.nvim
require("hlsearch").setup({})
