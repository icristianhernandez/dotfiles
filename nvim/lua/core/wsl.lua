local os = require("core.os")
if not os.IS_WSL then
    return
end

local function set_default_dir()
    local target_dir = "~/"

    local default_windows_paths = {
        "/mnt/c/Program Files/Neovide",
        "/mnt/c/Users/crist/OneDrive/Escritorio",
        "/mnt/c/Users/crist/Desktop",
        "/mnt/d/windows-app/Neovim/",
        "/mnt/d/windows-app/",
        "/mnt/d/windows-app",
    }

    local current_dir = vim.fn.getcwd()

    for _, path in ipairs(default_windows_paths) do
        if current_dir == path then
            vim.cmd("cd " .. target_dir)
            break
        end
    end
end

set_default_dir()

-- Set up WSL clipboard provider without mixing system and nvim clipboards
local function setup_wsl_clipboard()
    local wsl_clipboard_provider = {
        name = "WslClipboard",
        copy = {
            ["+"] = "clip.exe",
            ["*"] = "clip.exe",
        },
        paste = {
            ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }

    vim.g.clipboard = wsl_clipboard_provider
    -- Do NOT set vim.opt.clipboard = "unnamedplus" to avoid mixing nvim and OS clipboards
end

setup_wsl_clipboard()
