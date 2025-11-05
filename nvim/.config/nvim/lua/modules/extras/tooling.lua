local M = {}

-- Define stacks here. These are the single source of truth.
-- You can edit/extend these stacks; consumers just require this module.
local stacks = {
    -- Lua-specific tools
    lua = {
        lsps = { "lua_ls" },
        formatters_by_ft = { lua = { "stylua" } },
    },

    -- Web development (JS/TS/CSS/HTML/etc.)
    web_dev = {
        lsps = { "biome", "vtsls", "eslint", "cssls", "html" },
        formatters_by_ft = {
            javascript = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            typescript = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            json = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            css = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            html = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            markdown = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            yaml = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            javascriptreact = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            typescriptreact = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            scss = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            less = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            jsonc = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            vue = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            svelte = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
            graphql = {
                "prettierd",
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            },
        },
    },

    -- Nix ecosystem
    nix = {
        lsps = { { name = "nixd", install = false, enable = true } },
        formatters_by_ft = { nix = { "nixfmt" } },
        linters = { "statix" },
    },

    -- Dotfiles and shell tooling
    dotfiles = {
        linters = { { method = "diagnostics", name = "fish", installation = false } },
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

local function normalize_lsp(entry)
    if type(entry) == "string" then
        return { name = entry, install = true, enable = true }
    end
    local name = entry.name or entry[1]

    local install = entry.install
    if install == nil then
        install = entry.installation
    end
    if install == nil then
        install = true
    end

    local enable = entry.enable
    if enable == nil then
        enable = true
    end

    return { name = name, install = install, enable = enable }
end

local function normalize_formatter(entry)
    if type(entry) == "string" then
        return { name = entry, install = true }
    end
    local name = entry.name or entry[1]

    local install = entry.install
    if install == nil then
        install = entry.installation
    end
    if install == nil then
        install = true
    end

    return { name = name, install = install }
end

local function normalize_linter(entry)
    if type(entry) == "string" then
        return { name = entry, install = true, methods = nil }
    end
    local name = entry.name or entry[1]

    local install = entry.install
    if install == nil then
        install = entry.installation
    end
    if install == nil then
        install = true
    end

    local methods = entry.methods or (entry.method and { entry.method }) or nil

    return { name = name, install = install, methods = methods }
end

local function resolve(stacks_arg)
    local stacks_local = stacks_arg or stacks

    local lsp_enable_set, lsp_install_set = {}, {}
    local null_install_set = {}
    local nonels_init = {}
    local formatters_by_ft = {}

    local function apply_lsp(lsp_entry)
        local e = normalize_lsp(lsp_entry)
        if not e.enable then
            return
        end
        push(lsp_enable_set, e.name)
        if e.install then
            push(lsp_install_set, e.name)
        end
    end

    local function apply_formatter(fmt_entry)
        -- Only register installer presence; do not mutate formatters_by_ft here.
        local e = normalize_formatter(fmt_entry)
        if e.install then
            push(null_install_set, e.name)
        end
    end

    local function apply_linter(linter_entry)
        local e = normalize_linter(linter_entry)
        if e.install then
            push(null_install_set, e.name)
            return
        end
        -- non-autoinstall: register only in null-ls init
        if e.methods then
            for _, m in ipairs(e.methods) do
                table.insert(nonels_init, { method = m, name = e.name })
            end
        end
    end

    for _, stack in pairs(stacks_local) do
        -- LSPs
        if stack.lsps then
            for _, l in ipairs(stack.lsps) do
                apply_lsp(l)
            end
        end

        -- Formatters: merge per-stack Conform-shaped tables into one, and register names.
        if stack.formatters_by_ft then
            for ft, ftval in pairs(stack.formatters_by_ft) do
                local tgt = formatters_by_ft[ft]
                if not tgt then
                    tgt = {}
                    formatters_by_ft[ft] = tgt
                else
                    error(
                        "formatters_by_ft for filetype '"
                        .. tostring(ft)
                        .. "' defined in multiple stacks; duplicates are not allowed"
                    )
                end

                -- numeric entries: append in stack order, preserve duplicates
                for _, v in ipairs(ftval) do
                    local name
                    if type(v) == "string" then
                        name = v
                    elseif type(v) == "table" then
                        name = v.name or v[1]
                    else
                        name = tostring(v)
                    end

                    table.insert(tgt, name)
                    -- register installer / null-ls install using original entry
                    apply_formatter(ft)
                end

                -- copy non-numeric option keys (last-stack-wins)
                for k, v in pairs(ftval) do
                    if type(k) ~= "number" then
                        tgt[k] = v
                    end
                end
            end
        end

        -- Linters
        if stack.linters then
            for _, e in ipairs(stack.linters) do
                apply_linter(e)
            end
        end
    end

    return {
        mason_lspconfig = {
            ensure_installed = to_list(lsp_install_set),
            automatic_enable = to_list(lsp_enable_set),
        },
        conform = { formatters_by_ft = formatters_by_ft },
        mason_null_ls = { ensure_installed = to_list(null_install_set) },
        null_ls = { init = nonels_init },
    }
end

M.stacks = stacks
M.build = resolve
M.tooling = M.build(M.stacks)

return M
