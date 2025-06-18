-- Remove the default highlight yank autocmd group.
vim.api.nvim_del_augroup_by_name("lazyvim_highlight_yank")

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

-- Toggle for auto diagnostic floating window
local diagnostics_toggle = {
    enabled = false,
    augroup = vim.api.nvim_create_augroup("CursorHoldDiagnostics", { clear = true }),
}

local function enable_auto_diagnostics()
    vim.api.nvim_clear_autocmds({ group = diagnostics_toggle.augroup })
    vim.api.nvim_create_autocmd("CursorHold", {
        group = diagnostics_toggle.augroup,
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

local function disable_auto_diagnostics()
    vim.api.nvim_clear_autocmds({ group = diagnostics_toggle.augroup })
end

vim.keymap.set("n", "<leader>cD", function()
    diagnostics_toggle.enabled = not diagnostics_toggle.enabled
    if diagnostics_toggle.enabled then
        enable_auto_diagnostics()
        vim.notify("Auto diagnostics enabled", vim.log.levels.INFO)
    else
        disable_auto_diagnostics()
        vim.notify("Auto diagnostics disabled", vim.log.levels.INFO)
    end
end, { desc = "Toggle diagnostics on CursorHold" })

-- Initialize autocmd if enabled at startup
if diagnostics_toggle.enabled then
    enable_auto_diagnostics()
end
