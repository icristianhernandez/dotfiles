local M = {}

-- Define stacks here. These are the single source of truth.
-- You can edit/extend these stacks; consumers just require this module.
local stacks = {
    -- Lua-specific tools
    lua = {
        lsps = {
            "lua_ls",
        },
        formatters = {
            by_ft = {
                lua = { "stylua" },
            },
        },
    },

    -- Web development (JS/TS/CSS/HTML/etc.)
    web_dev = {
        lsps = {
            "vtsls",
            "eslint",
        },
        formatters = {
            by_ft = {
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                json = { "prettierd" },
                css = { "prettierd" },
                html = { "prettierd" },
                markdown = { "prettierd" },
                yaml = { "prettierd" },
                javascriptreact = { "prettierd" },
                typescriptreact = { "prettierd" },
                scss = { "prettierd" },
                less = { "prettierd" },
                jsonc = { "prettierd" },
                vue = { "prettierd" },
                svelte = { "prettierd" },
                graphql = { "prettierd" },
            },
        },
        -- example autoinstall linters (strings) could be added here, e.g. "eslint_d"
    },

    -- Nix ecosystem
    nix = {
        lsps = {
            { name = "nixd", install = false, enable = true },
        },
        formatters = {
            by_ft = {
                nix = { "nixfmt" },
            },
        },
        linters = {
            -- statix is handled by mason-null-ls (autoinstall), so plain string
            "statix",
        },
    },

    -- Dotfiles and shell tooling
    dotfiles = {
        linters = {
            -- Non-autoinstall example: fish diagnostics via null-ls only
            { method = "diagnostics", name = "fish", installation = false },
        },
    },
}

local function push(set, name)
    set[name] = true
end

local function to_list(set)
    local t = {}
    for k in pairs(set) do
        table.insert(t, k)
    end
    table.sort(t)
    return t
end

local function resolve()
    local lsp_enable_set, lsp_install_set = {}, {}
    local null_install_set = {}
    local nonels_init = {}
    local formatters_by_ft = {}

    for _, stack in pairs(stacks) do
        if stack.lsps then
            for _, l in ipairs(stack.lsps) do
                local name, install, enable
                if type(l) == "string" then
                    name, install, enable = l, true, true
                else
                    name = l.name or l[1]
                    install = l.install
                    if install == nil then
                        install = l.installation
                    end
                    if install == nil then
                        install = true
                    end
                    enable = l.enable
                    if enable == nil then
                        enable = true
                    end
                end
                if enable then
                    push(lsp_enable_set, name)
                end
                if install then
                    push(lsp_install_set, name)
                end
            end
        end

        if stack.formatters then
            local by_ft = stack.formatters.by_ft or stack.formatters
            for ft, val in pairs(by_ft) do
                local list = type(val) == "string" and { val } or val
                local ft_list = {}
                for _, item in ipairs(list) do
                    if type(item) == "string" then
                        table.insert(ft_list, item)
                        push(null_install_set, item)
                    else
                        local n = item.name or item[1]
                        table.insert(ft_list, n)
                        local install = item.install
                        if install == nil then
                            install = item.installation
                        end
                        if install == nil then
                            install = true
                        end
                        if install then
                            push(null_install_set, n)
                        end
                    end
                end
                formatters_by_ft[ft] = ft_list
            end
        end

        if stack.linters then
            for _, e in ipairs(stack.linters) do
                if type(e) == "string" then
                    -- Auto-install linters (strings): mason-null-ls handles install + enable
                    push(null_install_set, e)
                else
                    local n = e.name or e[1]
                    local install = e.install
                    if install == nil then
                        install = e.installation
                    end
                    if install == nil then
                        install = true
                    end
                    if install then
                        -- If autoinstall flagged true, let mason-null-ls handle it
                        push(null_install_set, n)
                    else
                        -- Non-autoinstall linters: add to manual null-ls init only
                        if e.methods then
                            for _, m in ipairs(e.methods) do
                                table.insert(nonels_init, { method = m, name = n })
                            end
                        elseif e.method then
                            table.insert(nonels_init, { method = e.method, name = n })
                        end
                    end
                end
            end
        end
    end

    return {
        mason_lspconfig = {
            ensure_installed = to_list(lsp_install_set),
            automatic_enable = to_list(lsp_enable_set),
        },
        conform = {
            formatters_by_ft = formatters_by_ft,
        },
        mason_null_ls = {
            ensure_installed = to_list(null_install_set),
        },
        null_ls = {
            init = nonels_init,
        },
    }
end

M.stacks = stacks
M.tooling = resolve()

return M
