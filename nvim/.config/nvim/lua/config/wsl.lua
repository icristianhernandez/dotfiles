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

    for _, path in ipairs(default_windows_paths) do
        if vim.fn.getcwd() == path then
            vim.cmd(string.format("cd %s", target_dir))
            break
        end
    end
end

-- Execute the function
set_default_dir()
