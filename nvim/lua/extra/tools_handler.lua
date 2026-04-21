local M = {}

local STACK_ORDER = {
    "backend",
    "frontend_web",
    "docs",
    "shell",
    "infra",
    "git",
    "core",
}

local TOOL_GROUPS = { "lsp", "treesitter", "formatters", "linters" }

local stacks = {
    backend = {
        lsp = { "basedpyright", "clangd", "postgres_lsp", "ruff" },
        treesitter = { "c", "cmake", "cpp", "go", "gomod", "gotmpl", "gowork", "python", "rust", "sql" },
        linters = {
            sql = { "sqlfluff" },
            python = {},
        },
    },
    frontend_web = {
        lsp = { "biome", "cssls", "denols", "html", "tsgo" },
        treesitter = {
            "astro",
            "css",
            "graphql",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "json5",
            "prisma",
            "pug",
            "scss",
            "svelte",
            "tsx",
            "twig",
            "typescript",
            "vue",
        },
        formatters = { "prettierd" },
        linters = {
            json = { "jsonlint" },
            javascript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescript = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            css = { "stylelint" },
            scss = { "stylelint" },
        },
    },
    docs = {
        lsp = { "marksman", "texlab", "tinymist" },
        treesitter = { "latex", "markdown", "markdown_inline", "mermaid", "typst" },
        formatters = { "latexindent" },
        linters = {
            markdown = { "markdownlint" },
        },
    },
    shell = {
        lsp = { "bashls", "fish_lsp" },
        treesitter = { "bash", "fish", "zsh" },
        formatters = { "beautysh", "fish_indent", "shfmt" },
        linters = {
            sh = { "shellcheck" },
            bash = { "shellcheck" },
            zsh = { "shellcheck" },
            fish = { "fish" },
        },
    },
    infra = {
        lsp = { "jsonls", "nixd", "taplo", "yamlls" },
        treesitter = { "dockerfile", "ini", "make", "meson", "nginx", "ninja", "nix", "toml", "yaml" },
        formatters = { "nixfmt" },
        linters = {
            nix = { "statix" },
            yaml = { "yamllint" },
        },
    },
    git = {
        treesitter = { "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore" },
        linters = {
            gitcommit = { "commitlint", "gitlint" },
        },
    },
    core = {
        lsp = { "lua_ls" },
        treesitter = { "lua", "regex", "vim", "vimdoc" },
        formatters = { "stylua" },
        linters = {
            lua = {},
        },
    },
}

local settings = {
    lsp = {
        jsonls = function()
            return {
                settings = {
                    json = {
                        validate = { enable = true },
                        schemas = require("schemastore").json.schemas(),
                    },
                },
            }
        end,
        yamlls = function()
            return {
                settings = {
                    yaml = {
                        schemaStore = { enable = false, url = "" },
                        schemas = require("schemastore").yaml.schemas(),
                    },
                },
            }
        end,
        nixd = function()
            local host = vim.env.NIXOS_HOST or os.getenv("NIXOS_HOST")
            local options = nil

            if type(host) == "string" and host:find("%S") ~= nil then
                options = {
                    nixos = {
                        expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations." .. host .. ".options",
                    },
                    ["home-manager"] = {
                        expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations."
                            .. host
                            .. ".options.home-manager.users.type.getSubOptions []",
                    },
                }
            end

            return {
                settings = {
                    nixd = {
                        nixpkgs = {
                            expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }",
                        },
                        options = options,
                    },
                },
            }
        end,
    },
    formatters = {
        by_ft = function()
            local function biome_filter(client)
                return client.name == "biome"
            end

            local function ruff_filter(client)
                return client.name == "ruff"
            end

            local function tinymist_filter(client)
                return client.name == "tinymist"
            end

            local function prettierd_biome()
                return {
                    "prettierd",
                    stop_after_first = true,
                    lsp_format = "first",
                    filter = biome_filter,
                }
            end

            local by_ft = {
                lua = { "stylua" },
                json = { "prettierd" },
                jsonc = { "prettierd" },
                yaml = { "prettierd" },
                yml = { "prettierd" },
                markdown = { "prettierd" },
                md = { "prettierd" },
                tex = { "latexindent" },
                typst = {
                    lsp_format = "first",
                    filter = tinymist_filter,
                },
                nix = { "nixfmt" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "beautysh" },
                fish = { "fish_indent" },
                python = {
                    lsp_format = "first",
                    filter = ruff_filter,
                },
            }

            for _, ft in ipairs({
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
            }) do
                by_ft[ft] = prettierd_biome()
            end

            return by_ft
        end,
    },
    linters = {},
}

local meta = {
    nixfmt = { install = false },
    nixd = { install = false },
    fish_indent = { install = false },
    fish = { install = false },
    statix = { install = false },
}

local function uniq_strings(values)
    local out = {}
    local seen = {}

    for _, value in ipairs(values or {}) do
        if type(value) == "string" and value:find("%S") ~= nil and not seen[value] then
            seen[value] = true
            table.insert(out, value)
        end
    end

    return out
end

function M.normalize_stacks(input)
    local normalized = {}

    for _, stack_name in ipairs(STACK_ORDER) do
        local stack = input[stack_name]
        if stack then
            normalized[stack_name] = {}
            for _, group in ipairs(TOOL_GROUPS) do
                if group == "linters" then
                    normalized[stack_name][group] = stack[group] or {}
                else
                    normalized[stack_name][group] = uniq_strings(stack[group])
                end
            end
        end
    end

    return normalized
end

function M.normalize_meta(input)
    local normalized = {}

    for tool, tool_meta in pairs(input or {}) do
        local value = type(tool_meta) == "table" and vim.deepcopy(tool_meta) or {}
        if value.install == nil then
            value.install = true
        end
        value.alias = value.alias or {}
        normalized[tool] = value
    end

    return normalized
end

local STACKS = M.normalize_stacks(stacks)
local META = M.normalize_meta(meta)

local function collect(group)
    local tools = {}
    local seen = {}

    for _, stack_name in ipairs(STACK_ORDER) do
        local stack = STACKS[stack_name]
        if stack then
            for _, tool in ipairs(stack[group] or {}) do
                if not seen[tool] then
                    seen[tool] = true
                    table.insert(tools, tool)
                end
            end
        end
    end

    return tools
end

local function alias_for(tool, consumer)
    local tool_meta = META[tool]
    if tool_meta and tool_meta.alias and tool_meta.alias[consumer] then
        return tool_meta.alias[consumer]
    end
    return tool
end

local function should_install(tool)
    local tool_meta = META[tool]
    if not tool_meta then
        return true
    end
    return tool_meta.install ~= false
end

local function collect_linter_tools()
    local tools = {}
    local seen = {}

    for _, stack_name in ipairs(STACK_ORDER) do
        local stack = STACKS[stack_name]
        if stack and stack.linters then
            for _, tools_for_ft in pairs(stack.linters) do
                for _, tool in ipairs(tools_for_ft) do
                    if not seen[tool] and should_install(tool) then
                        seen[tool] = true
                        table.insert(tools, tool)
                    end
                end
            end
        end
    end

    return tools
end

local function resolve_installed(group, consumer)
    local resolved = {}
    local seen = {}

    if group == "linters" then
        for _, tool in ipairs(collect_linter_tools()) do
            local name = alias_for(tool, consumer)
            if not seen[name] then
                seen[name] = true
                table.insert(resolved, name)
            end
        end
    else
        for _, tool in ipairs(collect(group)) do
            if should_install(tool) then
                local name = alias_for(tool, consumer)
                if not seen[name] then
                    seen[name] = true
                    table.insert(resolved, name)
                end
            end
        end
    end

    return resolved
end

local function resolve_lsp_settings()
    local resolved = {}

    for server, config in pairs(settings.lsp or {}) do
        if type(config) == "function" then
            resolved[server] = config()
        else
            resolved[server] = vim.deepcopy(config)
        end
    end

    return resolved
end

local function resolve_linters_by_ft()
    local by_ft = {}

    for _, stack_name in ipairs(STACK_ORDER) do
        local stack = STACKS[stack_name]
        if stack and stack.linters then
            for ft, tools in pairs(stack.linters) do
                if not by_ft[ft] then
                    by_ft[ft] = {}
                end
                for _, tool in ipairs(tools) do
                    if not vim.tbl_contains(by_ft[ft], tool) then
                        table.insert(by_ft[ft], tool)
                    end
                end
            end
        end
    end

    return by_ft
end

function M.resolve(target, opts)
    opts = opts or {}

    if target == "lsp" then
        return {
            ensure_installed = resolve_installed("lsp", "mason_lspconfig"),
            enable = collect("lsp"),
            settings = resolve_lsp_settings(),
        }
    end

    if target == "treesitter" then
        return {
            ensure_installed = resolve_installed("treesitter", "treesitter"),
        }
    end

    if target == "formatters" then
        return {
            ensure_installed = resolve_installed("formatters", "mason"),
            formatters_by_ft = settings.formatters.by_ft(),
        }
    end

    if target == "linters" then
        return {
            ensure_installed = resolve_installed("linters", "mason"),
            linters_by_ft = resolve_linters_by_ft(),
        }
    end

    error("tools_handler.resolve: unsupported target '" .. tostring(target) .. "'")
end

function M.resolve_all_ensure_installed()
    local seen = {}
    local result = {}

    for _, tool in ipairs(resolve_installed("linters", "mason")) do
        if not seen[tool] then
            seen[tool] = true
            table.insert(result, tool)
        end
    end
    for _, tool in ipairs(resolve_installed("formatters", "mason")) do
        if not seen[tool] then
            seen[tool] = true
            table.insert(result, tool)
        end
    end

    return result
end

M.stacks = STACKS
M.settings = settings
M.meta = META

return M
