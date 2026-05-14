local tools = require("extra.tools_resolver")

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})

vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-treesitter/nvim-treesitter-context",
    "https://github.com/MeanderingProgrammer/treesitter-modules.nvim",
})

local treesitter = tools.resolve("treesitter")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if vim.tbl_contains({ "msg", "cmd", "dialog", "pager" }, ft) then
            return
        end
        pcall(vim.treesitter.start, args.buf)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

require("treesitter-context").setup({
    max_lines = 1,
    multiline_threshold = 1,
    min_window_height = 20,
})

require("treesitter-modules").setup({
    ensure_installed = treesitter.ensure_installed,
    auto_install = true,
})
