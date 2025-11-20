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
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    command = "wincmd T",
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
    command = "wincmd =",
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
    pattern = { ".env", ".env.*" },
    callback = function()
        vim.bo.filetype = "dosini"
    end,
})

-- show cursorline only in active focused windows
-- enable cursorline for active window
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
    callback = function()
        vim.opt_local.cursorline = true
    end,
})
-- disable cursorline for inactive window
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = "active_cursorline",
    callback = function()
        vim.opt_local.cursorline = false
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
        local file = vim.fn.resolve(event.match)
        if file == nil or file == "" then
            file = event.match
        end
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- restore cursor to file position in previous editing session
local lastloc_excluded_filetypes = vim.g.lastloc_excluded_filetypes
    or { "gitcommit", "gitrebase", "NeogitCommitMessage" }
local lastloc_excluded_basenames = vim.g.lastloc_excluded_basenames or { "COMMIT_EDITMSG", "MERGE_MSG", "TAG_EDITMSG" }

local function lastloc_is_excluded(bufnr)
    if not bufnr or bufnr == 0 then
        return false
    end

    local ft = vim.bo[bufnr].filetype or ""
    if ft ~= "" and vim.tbl_contains(lastloc_excluded_filetypes, ft) then
        return true
    end
    local name = vim.api.nvim_buf_get_name(bufnr) or ""
    local base = ""
    if name and name ~= "" then
        base = vim.fn.fnamemodify(name, ":t")
    end
    if base ~= "" and (vim.tbl_contains(lastloc_excluded_basenames, base) or base:match("EDITMSG$")) then
        return true
    end
    return false
end

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
        if lastloc_is_excluded(args.buf) or vim.b[args.buf].lastloc_restored then
            return
        end
        vim.b[args.buf].lastloc_restored = true

        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.api.nvim_win_set_cursor(0, mark)
            -- defer centering slightly so it's applied after render
            vim.schedule(function()
                if vim.bo[args.buf].buftype ~= "terminal" then
                    pcall(function()
                        vim.cmd("normal! zz")
                    end)
                end
            end)
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
