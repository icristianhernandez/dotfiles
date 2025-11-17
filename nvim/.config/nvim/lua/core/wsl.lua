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
