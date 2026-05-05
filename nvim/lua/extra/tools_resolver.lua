local stacks = require("extra.tool_stacks")

local M = {}

local function flatten_list(domains, key)
    local out = {}
    local seen = {}
    for _, domain in ipairs(domains) do
        local list = domain[key]
        if list then
            for _, item in ipairs(list) do
                local name = type(item) == "string" and item or item.name
                if not seen[name] then
                    seen[name] = true
                    table.insert(out, item)
                end
            end
        end
    end
    return out
end

local function merge_ft_tables(domains, key)
    local out = {}
    for _, domain in ipairs(domains) do
        local ft_table = domain[key]
        if ft_table then
            for ft, config in pairs(ft_table) do
                out[ft] = config
            end
        end
    end
    return out
end

local function extract_names(entries)
    local out = {}
    for _, entry in ipairs(entries) do
        table.insert(out, type(entry) == "string" and entry or entry.name)
    end
    return out
end

local function extract_names_from_ft(ft_table)
    local seen = {}
    local out = {}
    for _, config in pairs(ft_table) do
        for _, item in ipairs(config) do
            if type(item) == "string" and not seen[item] then
                seen[item] = true
                table.insert(out, item)
            end
        end
    end
    return out
end

local function filter_skip_install(tools)
    local out = {}
    for _, tool in ipairs(tools) do
        if not vim.tbl_contains(stacks.skip_install, tool) then
            table.insert(out, tool)
        end
    end
    return out
end

local function resolve_lsp_settings(entries)
    local resolved = {}
    for _, entry in ipairs(entries) do
        if type(entry) == "table" and entry.settings then
            resolved[entry.name] = type(entry.settings) == "function" and entry.settings()
                or vim.deepcopy(entry.settings)
        end
    end
    return resolved
end

local lsp_entries = flatten_list(stacks.domains, "lsp")
local lsp_names = extract_names(lsp_entries)

local treesitter_names = extract_names(flatten_list(stacks.domains, "treesitter"))

local formatters_by_ft = merge_ft_tables(stacks.domains, "formatters_by_ft")
formatters_by_ft.jsonc = formatters_by_ft.json
formatters_by_ft.md = formatters_by_ft.markdown
formatters_by_ft.yml = formatters_by_ft.yaml

local formatters_names = extract_names_from_ft(formatters_by_ft)

local linters_by_ft = merge_ft_tables(stacks.domains, "linters_by_ft")

local linters_names
do
    local seen = {}
    local out = {}
    for _, tools in pairs(linters_by_ft) do
        for _, tool in ipairs(tools) do
            if not seen[tool] then
                seen[tool] = true
                table.insert(out, tool)
            end
        end
    end
    linters_names = out
end

local mason_tools
do
    local seen = {}
    local out = {}
    for _, tool in ipairs(filter_skip_install(linters_names)) do
        seen[tool] = true
        table.insert(out, tool)
    end
    for _, tool in ipairs(filter_skip_install(formatters_names)) do
        if not seen[tool] then
            seen[tool] = true
            table.insert(out, tool)
        end
    end
    mason_tools = out
end

function M.resolve(target)
    if target == "lsp" then
        return {
            ensure_installed = filter_skip_install(lsp_names),
            enable = vim.deepcopy(lsp_names),
            settings = resolve_lsp_settings(lsp_entries),
        }
    elseif target == "treesitter" then
        return {
            ensure_installed = filter_skip_install(treesitter_names),
        }
    elseif target == "formatters" then
        return {
            ensure_installed = filter_skip_install(formatters_names),
            formatters_by_ft = formatters_by_ft,
        }
    elseif target == "linters" then
        return {
            ensure_installed = filter_skip_install(linters_names),
            linters_by_ft = linters_by_ft,
        }
    else
        error("tools_resolver.resolve: unsupported target '" .. tostring(target) .. "'")
    end
end

function M.resolve_mason_tools()
    return mason_tools
end

return M
