-- Simplified centralized Neovim tooling (lsp's, formatters, linters, etc.)

local M = {}

-- Stacks are the single source of truth. All stacks are aggregated.
-- Schema: each stack has optional lsp.servers (table), formatters.by_ft (table), linters.by_ft (table).
M.stacks = {
    common = {
        linters = {
            by_ft = {
                ["_"] = {},
                ["*"] = {},
            },
        },
    },

    web = {
        lsp = {
            servers = {
                vtsls = {},
                denols = {},
                html = {},
                cssls = {},
                biome = {},
            },
        },
        formatters = {
            by_ft = {
                -- Prefer Biome when a Biome config exists; fall back to Prettier
                javascript = { "biome", "prettierd", "prettier" },
                javascriptreact = { "biome", "prettierd", "prettier" },
                typescript = { "biome", "prettierd", "prettier" },
                typescriptreact = { "biome", "prettierd", "prettier" },
                -- For filetypes Biome doesn't handle, keep Prettier only
                html = { "prettierd", "prettier" },
                css = { "prettierd", "prettier" },
            },
        },
        linters = {
            by_ft = {
                javascript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescript = { "eslint_d" },
                typescriptreact = { "eslint_d" },
            },
        },
    },

    -- Extracted data/docs related filetypes
    content = {
        lsp = {
            servers = {
                jsonls = {},
                yamlls = {},
                marksman = {},
            },
        },
        formatters = {
            by_ft = {
                json = { "biome", "prettierd", "prettier" },
                yaml = { "prettierd", "prettier" },
                markdown = { "prettierd", "prettier" },
            },
        },
        linters = {
            by_ft = {
                markdown = { "markdownlint-cli2" },
            },
        },
    },

    python = {
        lsp = {
            servers = {
                basedpyright = {},
                ruff = {},
            },
        },
        formatters = {
            by_ft = {
                python = { "ruff_format", "black" },
            },
        },
    },

    lua = {
        lsp = {
            servers = {
                lua_ls = {},
            },
        },
        formatters = {
            by_ft = {
                lua = { "stylua" },
            },
        },
    },

    nix = {
        lsp = {
            servers = {
                nixd = {},
            },
        },
        formatters = {
            by_ft = {
                nix = { "nixfmt" },
            },
        },
        linters = {
            by_ft = {
                nix = { "statix" },
            },
        },
    },

    shell = {
        lsp = {
            servers = {
                bashls = {},
            },
        },
        linters = {
            by_ft = {
                fish = { "fish" },
                sh = { "shellcheck" },
                bash = { "shellcheck" },
                zsh = { "shellcheck" },
            },
        },
        formatters = {
            by_ft = {
                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },
            },
        },
    },

    c_cpp = {
        lsp = {
            servers = {
                clangd = {},
            },
        },
    },

    toml = {
        lsp = {
            servers = {
                taplo = {},
            },
        },
    },

    sql = {
        linters = {
            by_ft = {
                sql = { "sqlfluff" },
            },
        },
    },
}

M.mason = {
    skip_tools = { fish = true, statix = true, nixfmt = true },
    extra_tools = { "markdown-toc" },
}

-- Shared conditions and helpers used by consumers
M.conditions = {}

function M.conditions.is_biome_project(filename)
    local util = require("lspconfig.util")
    return util.root_pattern("biome.json", "biome.jsonc")(filename) ~= nil
end

function M.conditions.has_prettier_config(filename)
    local util = require("lspconfig.util")
    local root = util.root_pattern(
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.js",
        ".prettierrc.cjs",
        ".prettierrc.yaml",
        ".prettierrc.yml",
        "prettier.config.js",
        "prettier.config.cjs",
        "prettier.config.ts",
        "package.json"
    )(filename)
    if not root then
        return false
    end
    -- If package.json is the match, ensure it contains a "prettier" field
    local pkg = root .. "/package.json"
    local stat = vim.uv.fs_stat(pkg)
    if stat and stat.type == "file" then
        local ok, data = pcall(vim.fn.readfile, pkg)
        if ok and data then
            local ok2, json = pcall(vim.json.decode, table.concat(data, "\n"))
            if ok2 and type(json) == "table" and json.prettier ~= nil then
                return true
            end
        end
        return false
    end
    return true
end

-- Conform formatter configuration (names -> options)
M.formatters = M.formatters or {}
M.formatters.config = {
    injected = { options = { ignore_errors = true } },
    biome = {
        condition = function(ctx)
            return M.conditions.is_biome_project(ctx.filename)
        end,
    },
    prettierd = {
        condition = function(ctx)
            if M.conditions.is_biome_project(ctx.filename) then
                return false
            end
            return M.conditions.has_prettier_config(ctx.filename)
        end,
    },
    prettier = {
        condition = function(ctx)
            if M.conditions.is_biome_project(ctx.filename) then
                return false
            end
            return M.conditions.has_prettier_config(ctx.filename)
        end,
    },
}

-- nvim-lint linters configuration (names -> options)
M.linters = M.linters or { by_ft = M.stacks.common.linters.by_ft }
M.linters.config = {
    eslint_d = {
        condition = function(ctx)
            return not M.conditions.is_biome_project(ctx.filename)
        end,
    },
}

local function sorted_keys(tbl)
    local keys = {}
    for name, _ in pairs(tbl or {}) do
        keys[#keys + 1] = name
    end
    table.sort(keys)
    return keys
end

local function sorted_unique_values(list_of_lists, skip)
    local seen = {}
    for _, items in ipairs(list_of_lists or {}) do
        for _, item in ipairs(items or {}) do
            if not (skip and skip[item]) then
                seen[item] = true
            end
        end
    end
    local result = {}
    for item in pairs(seen) do
        result[#result + 1] = item
    end
    table.sort(result)
    return result
end

local function merge_by_ft(dst, src)
    dst = dst or {}
    for ft, items in pairs(src or {}) do
        local existing = dst[ft] or {}
        local seen = {}
        for _, v in ipairs(existing) do
            seen[v] = true
        end
        for _, v in ipairs(items) do
            if not seen[v] then
                existing[#existing + 1] = v
                seen[v] = true
            end
        end
        dst[ft] = existing
    end
    return dst
end

local function aggregate()
    local result = {
        lsp = { servers = {} },
        formatters = { by_ft = {} },
        linters = { by_ft = {} },
    }

    for _, key in ipairs(sorted_keys(M.stacks or {})) do
        local st = M.stacks[key] or {}

        for name, cfg in pairs((st.lsp or {}).servers or {}) do
            result.lsp.servers[name] = cfg or {}
        end

        merge_by_ft(result.formatters.by_ft, (st.formatters or {}).by_ft)
        merge_by_ft(result.linters.by_ft, (st.linters or {}).by_ft)
    end

    return result
end

local aggregated = aggregate()

M.lsp = { servers = aggregated.lsp.servers }
M.formatters = { by_ft = aggregated.formatters.by_ft, config = M.formatters.config }
M.linters = { by_ft = aggregated.linters.by_ft, config = M.linters.config }

local all_formatters = {}
for _, tools in pairs(M.formatters.by_ft or {}) do
    all_formatters[#all_formatters + 1] = tools
end

local all_linters = {}
for _, tools in pairs(M.linters.by_ft or {}) do
    all_linters[#all_linters + 1] = tools
end

M.mason.auto_install = {
    lsp = sorted_keys(M.lsp.servers or {}),
    formatters = sorted_unique_values(all_formatters, M.mason.skip_tools),
    linters = sorted_unique_values(all_linters, M.mason.skip_tools),
}

M.mason.auto_install.tools =
    sorted_unique_values({ M.mason.auto_install.formatters, M.mason.auto_install.linters, M.mason.extra_tools or {} })

return M
