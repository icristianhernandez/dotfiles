--- Tooling stacks for LSPs, formatters, and linters.
--- Consumers require this module and either use `M.tooling` or call `M.build(M.stacks)`.
local M = {}

---@alias Filetype string
---@class LspEntry
---@field name string
---@field install? boolean
---@field installation? boolean
---@field enable? boolean
---@field config? table
---@class FormatterEntry
---@field name string
---@field install? boolean
---@field installation? boolean
---@class LinterEntry
---@field name string
---@field install? boolean
---@field installation? boolean
---@field methods? string[]|nil
---@field method? string|nil

--- Utility: check for non-empty string (non-whitespace).
--- @param s any
--- @return boolean
local function is_nonempty_string(s)
    return type(s) == "string" and s:find("%S") ~= nil
end

--- Create a Conform per-filetype entry.
--
-- The returned table uses index 1 for the formatter name (Conform numeric entry)
-- and copies any option keys from `opts` as non-numeric keys.
--
-- @param name string Formatter/tool name (e.g. "prettierd")
-- @param opts table|nil Per-filetype options passed to Conform (optional)
-- @return table Conform-shaped entry
local function make_conform_filetype_entry(name, opts)
    local entry = { name }
    if opts then
        for option_key, option_value in pairs(opts) do
            entry[option_key] = option_value
        end
    end
    return entry
end

--- Map a list of filetypes to a fresh Conform entry produced by `factory`.
--
-- Each filetype gets a new table instance so modifications do not share state.
--
-- @param filetypes table Array of filetype strings
-- @param factory function Function that returns a new Conform entry
-- @return table Map of filetype -> Conform entry
local function map_filetypes_to_conform_entries(filetypes, factory)
    local result = {}
    for _, filetype in ipairs(filetypes) do
        result[filetype] = factory()
    end
    return result
end

--- Define stacks here. These are the single source of truth for tooling.
--
-- Shape (per stack):
-- {
--   lsps = { <string|table>... },
--   parsers = { <string|table>... },
--   formatters_by_ft = { ft = { <string|table>..., opt_key = ... } },
--   linters = { { name=string, ... }|string ... },
-- }
local stacks = {
    -- Lua-specific tools (for Neovim, primarily)
    lua = {
        lsps = { "lua_ls" },
        parsers = { "lua" },
        formatters_by_ft = { lua = { "stylua" } },
    },

    -- Web development (JS/TS/CSS/HTML/etc.)
    frontend_web = {
        lsps = { "biome", "vtsls", "eslint", "cssls", "html" },
        parsers = { "javascript", "typescript", "tsx", "css", "html", "scss", "less", "vue", "svelte", "graphql" },
        formatters_by_ft = (function()
            local common_opts = {
                stop_after_first = true,
                lsp_format = "first",
                filter = function(client)
                    return client.name == "biome"
                end,
            }

            -- Factory that returns a fresh prettierd-shaped entry each time.
            local prettierd_factory = function()
                return make_conform_filetype_entry("prettierd", common_opts)
            end

            local filetypes = {
                "javascript",
                "typescript",
                "css",
                "html",
                "javascriptreact",
                "typescriptreact",
                "scss",
                "less",
                "vue",
                "svelte",
                "graphql",
            }

            return map_filetypes_to_conform_entries(filetypes, prettierd_factory)
        end)(),
    },

    -- Data and docs: JSON, YAML, Markdown, TOML
    data_and_docs = {
        parsers = { "json", "yaml", "markdown", "toml" },
        lsps = {
            "marksman",
            "taplo",
            {
                name = "jsonls",
                config = function()
                    local schemastore = require("schemastore")
                    return {
                        settings = {
                            json = {
                                validate = { enable = true },
                                schemas = schemastore.json.schemas(),
                            },
                        },
                    }
                end,
            },
            {
                name = "yamlls",
                config = function()
                    local schemastore = require("schemastore")
                    return {
                        settings = {
                            yaml = {
                                schemaStore = { enable = false, url = "" },
                                schemas = schemastore.yaml.schemas(),
                            },
                        },
                    }
                end,
            },
        },
        -- Use prettierd for all formatting of data files; do not rely on LSP formatting.
        formatters_by_ft = (function()
            local prettierd_factory = function()
                return make_conform_filetype_entry("prettierd")
            end

            local filetypes = {
                "json",
                "jsonc",
                "yaml",
                "yml",
                "markdown",
                "md",
            }

            return map_filetypes_to_conform_entries(filetypes, prettierd_factory)
        end)(),
        -- Linters: use yamllint for YAML, markdownlint for Markdown, and jsonlint for JSON (optional validator).
        linters = { "yamllint", "markdownlint-cli2", "jsonlint" },
    },

    -- Nix ecosystem
    nix = {
        lsps = { { name = "nixd", install = false, enable = true } },
        formatters_by_ft = { nix = { { name = "nixfmt", install = false } } },
        linters = { "statix" },
    },

    -- Dotfiles and shell tooling
    shell = {
        lsps = { "bashls", "fish_lsp" },
        parsers = { "bash", "fish", "zsh" },
        formatters_by_ft = { sh = { "shfmt" }, bash = { "shfmt" }, zsh = { "beautysh" }, fish = { "fish_indent" } },
        linters = {
            { method = "diagnostics", name = "fish", install = false },
            { "shellcheck" },
        },
    },

    python = {
        lsps = { "ruff", "basedpyright" },
        parsers = { "python" },
        -- format python via lsp fallback with filter to ruff
        formatters_by_ft = {
            python = {
                lsp_format = "first",
                filter = function(client)
                    return client.name == "ruff"
                end,
            },
        },
    },

    c_cpp = {
        lsps = { "clangd" },
        parsers = { "c", "cpp" },
    },

    databases = {
        parsers = { "sql" },
        -- lsps = { "sqls" },

        -- Formatting: prefer a dedicated SQL formatter for SQL filetypes.
        formatters_by_ft = (function()
            local sql_formatter_factory = function()
                return make_conform_filetype_entry("pg_format", {
                    stop_after_first = true,
                    lsp_format = "first",
                })
            end

            local filetypes = {
                "sql",
                "pgsql",
                "mysql",
                "plsql",
            }

            return map_filetypes_to_conform_entries(filetypes, sql_formatter_factory)
        end)(),

        linters = {
            { name = "sqlfluff", install = true },
        },
    },
}

--- Add `name` to set table (map-as-set).
-- @param set table Set table (map keys -> true)
-- @param name string Key to add
local function add_to_set(set, name)
    set[name] = true
end

--- Convert a set (map keys->true) into a sorted list of keys.
-- @param set table
-- @return table Sorted array of keys
local function sorted_set_keys(set)
    local keys = {}
    for key in pairs(set) do
        table.insert(keys, key)
    end
    table.sort(keys)
    return keys
end

--- Normalize an LSP entry.
--
-- Accepts either a string (name) or a table with keys:
-- - name or [1]
-- - install or installation (boolean, defaults true)
-- - enable (boolean, defaults true)
-- - config (table, optional)
--
-- @param entry string|table
-- @return table { name=string, install=boolean, enable=boolean, config=table|nil }
local function normalize_lsp(entry)
    if type(entry) == "string" then
        return { name = entry, install = true, enable = true, config = nil }
    end
    local name = entry.name or entry[1]
    if not is_nonempty_string(name) then
        error("lsp entry missing valid name")
    end

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

    local config = entry.config
    if config ~= nil and type(config) ~= "table" and type(config) ~= "function" then
        error("lsp entry 'config' must be a table or function if provided")
    end

    return { name = name, install = install, enable = enable, config = config }
end

--- Normalize a formatter entry.
--
-- Accepts either a string (name) or a table with keys:
-- - name or [1]
-- - install or installation (boolean, defaults true)
--
-- @param entry string|table
-- @return table { name=string, install=boolean }
local function normalize_formatter(entry)
    if type(entry) == "string" then
        return { name = entry, install = true }
    end
    local name = entry.name or entry[1]
    if not is_nonempty_string(name) then
        error("formatter entry missing valid name")
    end

    local install = entry.install
    if install == nil then
        install = entry.installation
    end
    if install == nil then
        install = true
    end

    return { name = name, install = install }
end

--- Normalize a linter entry.
--
-- Accepts either a string (name) or a table with keys:
-- - name or [1]
-- - install or installation (boolean, defaults true)
-- - methods or method (string or array) — optional
--
-- @param entry string|table
-- @return table { name=string, install=boolean, methods=table|nil }
local function normalize_linter(entry)
    if type(entry) == "string" then
        return { name = entry, install = true, methods = nil }
    end
    local name = entry.name or entry[1]
    if not is_nonempty_string(name) then
        error("linter entry missing valid name")
    end

    local install = entry.install
    if install == nil then
        install = entry.installation
    end
    if install == nil then
        install = true
    end

    -- Normalize and validate methods/ method fields
    local methods = nil
    if entry.methods ~= nil then
        if type(entry.methods) ~= "table" then
            error("linter entry 'methods' must be a table of strings")
        end
        -- ensure all elements are non-empty strings
        for _, m in ipairs(entry.methods) do
            if not is_nonempty_string(m) then
                error("linter entry 'methods' must contain non-empty string values")
            end
        end
        methods = entry.methods
    elseif entry.method ~= nil then
        if not is_nonempty_string(entry.method) then
            error("linter entry 'method' must be a non-empty string")
        end
        methods = { entry.method }
    end

    return { name = name, install = install, methods = methods }
end

local function normalize_parser(entry)
    if type(entry) == "string" then
        return { name = entry, install = true }
    end
    local name = entry.name or entry[1]
    if not is_nonempty_string(name) then
        error("parser entry missing valid name")
    end
    local install = entry.install
    if install == nil then
        install = entry.installation
    end
    if install == nil then
        install = true
    end
    return { name = name, install = install }
end

--- Build the tooling configuration from stacks.
--
-- Merges stacks and returns a table shaped for consumers:
-- {
--   mason_lspconfig = { ensure_installed = {...}, automatic_enable = {...}, configs = { server = {..} } },
--   conform = { formatters_by_ft = { ft = { <string|table>..., opt_key=... } } },
--   mason_null_ls = { ensure_installed = {...} },
--   null_ls = { init = { { method=..., name=... }, ... } }
-- }
--
-- Duplicate filetype keys across stacks are an error (deterministic merge requirement).
-- Duplicate LSP configs across stacks are an error.
-- Formatter numeric entries preserve duplicates and order; installer sets are deduped and sorted.
--
-- @param stacks_arg table|nil Optional stacks map; defaults to internal `stacks`.
-- @return table tooling configuration
local function build_tooling_config(stacks_arg)
    local stacks_local = stacks_arg or stacks

    local enabled_lsp_names_set, install_lsp_names_set = {}, {}
    local parser_names_set = {}
    local null_ls_installer_names_set = {}
    local null_ls_manual_initializations = {}
    local formatters_by_filetype = {}
    local lsp_configs_by_name = {}

    local function apply_lsp(lsp_entry)
        local normalized = normalize_lsp(lsp_entry)
        if not normalized.enable then
            return
        end
        add_to_set(enabled_lsp_names_set, normalized.name)
        if normalized.install then
            add_to_set(install_lsp_names_set, normalized.name)
        end
        if normalized.config ~= nil then
            if lsp_configs_by_name[normalized.name] ~= nil then
                error(
                    "lsp config for '"
                        .. tostring(normalized.name)
                        .. "' defined in multiple stacks; duplicates are not allowed"
                )
            end
            lsp_configs_by_name[normalized.name] = normalized.config
        end
    end

    local function apply_formatter(formatter_entry)
        local normalized = normalize_formatter(formatter_entry)
        if normalized.install then
            add_to_set(null_ls_installer_names_set, normalized.name)
        end
        return normalized
    end

    local function apply_linter(linter_entry)
        local normalized = normalize_linter(linter_entry)
        -- install=true → handled by mason-null-ls (ensure_installed)
        if normalized.install then
            add_to_set(null_ls_installer_names_set, normalized.name)
            return
        end
        -- install=false with methods → manual null-ls registration entries
        if normalized.methods then
            for _, method in ipairs(normalized.methods) do
                table.insert(null_ls_manual_initializations, { method = method, name = normalized.name })
            end
        end
        -- install=false and no methods → intentionally ignored
    end

    local function apply_parser(parser_entry)
        local normalized = normalize_parser(parser_entry)
        if normalized.install then
            add_to_set(parser_names_set, normalized.name)
        end
    end

    for _, stack in pairs(stacks_local) do
        if stack.lsps then
            for _, lsp_entry in ipairs(stack.lsps) do
                apply_lsp(lsp_entry)
            end
        end

        if stack.parsers then
            for _, parser_entry in ipairs(stack.parsers) do
                apply_parser(parser_entry)
            end
        end

        if stack.formatters_by_ft then
            for filetype, filetype_spec in pairs(stack.formatters_by_ft) do
                local merged_spec_for_filetype = formatters_by_filetype[filetype]
                if not merged_spec_for_filetype then
                    merged_spec_for_filetype = {}
                    formatters_by_filetype[filetype] = merged_spec_for_filetype
                else
                    error(
                        "formatters_by_ft for filetype '"
                            .. tostring(filetype)
                            .. "' defined in multiple stacks; duplicates are not allowed"
                    )
                end

                -- numeric entries: append names in order; preserve duplicates
                for _, formatter_entry in ipairs(filetype_spec) do
                    if type(formatter_entry) ~= "string" and type(formatter_entry) ~= "table" then
                        error("formatter numeric entry must be string or table")
                    end
                    local normalized = normalize_formatter(formatter_entry)
                    table.insert(merged_spec_for_filetype, normalized.name)
                    apply_formatter(formatter_entry)

                    -- if the numeric entry is a table, copy its non-numeric option keys (preserve per-entry options)
                    if type(formatter_entry) == "table" then
                        for k, v in pairs(formatter_entry) do
                            if type(k) ~= "number" and k ~= "name" and k ~= "install" and k ~= "installation" then
                                -- don't overwrite keys already set by filetype-level options
                                if merged_spec_for_filetype[k] == nil then
                                    merged_spec_for_filetype[k] = v
                                end
                            end
                        end
                    end
                end

                -- copy non-numeric option keys from this stack's spec
                for key, value in pairs(filetype_spec) do
                    if type(key) ~= "number" then
                        merged_spec_for_filetype[key] = value
                    end
                end
            end
        end

        if stack.linters then
            for _, linter_entry in ipairs(stack.linters) do
                apply_linter(linter_entry)
            end
        end
    end

    return {
        mason_lspconfig = {
            ensure_installed = sorted_set_keys(install_lsp_names_set),
            automatic_enable = sorted_set_keys(enabled_lsp_names_set),
            configs = lsp_configs_by_name,
        },
        conform = { formatters_by_ft = formatters_by_filetype },
        mason_null_ls = { ensure_installed = sorted_set_keys(null_ls_installer_names_set) },
        null_ls = { init = null_ls_manual_initializations },
        treesitter = { ensure_installed = sorted_set_keys(parser_names_set) },
    }
end

M.stacks = stacks
M.build = build_tooling_config
M.tooling = M.build(M.stacks)

return M
