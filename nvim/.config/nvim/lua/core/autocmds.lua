-- Clear the SignColumn background color on any colorscheme change.
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.cmd("hi clear SignColumn")
    end,
})

-- Disable auto-commenting for all file types.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove("o")
    end,
})

-- Open all help pages in a new tab (except for the case of replacing help
-- pages, where just replace, don't create multiple help-tab pages)
-- ^^ the above can be changed, but really can be easily avoided if it's wanted
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
        if vim.fn.getbufvar("%", "&filetype") == "help" then
            vim.cmd("wincmd T")
        end
    end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = vim.api.nvim_create_augroup("CheckFilesChanged", { clear = true }),
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = vim.api.nvim_create_augroup("CreateIntermediateDirs", { clear = true }),
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("LastLoC", { clear = true }),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Toggle for auto diagnostic floating window
local augroup = vim.api.nvim_create_augroup("CursorHoldDiagnostics", { clear = true })
local enabled = false

local function set_auto_diagnostics(on)
    vim.api.nvim_clear_autocmds({ group = augroup })
    if not on then
        return
    end
    vim.api.nvim_create_autocmd("CursorHold", {
        group = augroup,
        callback = function()
            vim.diagnostic.open_float(nil, {
                focusable = false,
                source = "if_many",
                close_events = {
                    "CursorMoved",
                    "CursorMovedI",
                    "BufHidden",
                    "InsertCharPre",
                    "WinLeave",
                    "BufWrite",
                    "BufDelete",
                },
            })
        end,
    })
end

vim.keymap.set("n", "<leader>cD", function()
    enabled = not enabled
    set_auto_diagnostics(enabled)
    vim.notify(("Auto diagnostics %s"):format(enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Toggle diagnostics on CursorHold" })

-- initialize at startup if you want (enabled is false by default)
set_auto_diagnostics(enabled)

-- Ensure LSP reference highlights are underlined and survive colorscheme changes.
local function apply_lsp_reference_hl()
    vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true })
end

local lsp_ref_augroup = vim.api.nvim_create_augroup("LspReferenceHighlights", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
    group = lsp_ref_augroup,
    pattern = "*",
    callback = apply_lsp_reference_hl,
})

-- Apply at startup so highlights are present immediately.
apply_lsp_reference_hl()
