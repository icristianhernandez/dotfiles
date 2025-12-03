local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "modules" },
    },
    defaults = {
        lazy = false,
        version = false,
    },
    checker = {
        enabled = true, -- check for plugin updates periodically
        notify = false, -- notify on update
    }, -- automatically check for plugin updates
    change_detection = {
        enabled = true,
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "netrwPlugin",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- Expose a keymap to open Lazy's UI. Use a function so the underlying API is
-- invoked at keypress time and doesn't error if lazy isn't fully loaded yet.
vim.keymap.set("n", "<leader>l", function()
    local ok, lazy = pcall(require, "lazy")
    if ok and lazy and type(lazy.home) == "function" then
        lazy.home()
    else
        vim.cmd("Lazy")
    end
end, { desc = "Open Lazy" })

vim.api.nvim_create_user_command("LazyHealth", function()
    vim.cmd([[Lazy! load all]])
    vim.cmd([[checkhealth]])
end, { desc = "Load all plugins and run :checkhealth" })
