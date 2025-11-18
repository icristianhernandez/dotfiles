local os = require("core.os")

require("core.options")
require("core.keymaps")
require("core.autocmds")

if vim.g.neovide then
    require("core.neovide")
end

if os.IS_WSL then
    require("core.wsl")
end

require("core.lazy-setup")
