local desired_initial_dir = "~/"

local windows_default_paths = {
  "/mnt/c/Program Files/Neovide",
  "/mnt/c/Users/crist/OneDrive/Escritorio",
  "/mnt/c/Users/crist/Desktop",
  "/mnt/d/windows-app/Neovim/",
}

for _, default_path in ipairs(windows_default_paths) do
  if vim.fn.getcwd() == default_path then
    vim.cmd("cd " .. desired_initial_dir)
    break
  end
end
