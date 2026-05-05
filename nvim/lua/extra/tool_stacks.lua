local M = {}

local function FILTER_BIOME(client)
    return client.name == "biome"
end

local function FILTER_RUFF(client)
    return client.name == "ruff"
end

local function FILTER_TINY_MIST(client)
    return client.name == "tinymist"
end

local function pb()
    return {
        "prettierd",
        stop_after_first = true,
        lsp_format = "first",
        filter = FILTER_BIOME,
    }
end

local function jsonls_settings()
    return {
        settings = {
            json = {
                validate = { enable = true },
                schemas = require("schemastore").json.schemas(),
            },
        },
    }
end

local function yamlls_settings()
    return {
        settings = {
            yaml = {
                schemaStore = { enable = false, url = "" },
                schemas = require("schemastore").yaml.schemas(),
            },
        },
    }
end

local function nixd_settings()
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
end

M.domains = {
    {
        name = "backend",
        lsp = { "basedpyright", "clangd", "postgres_lsp", "ruff" },
        treesitter = { "c", "cmake", "cpp", "go", "gomod", "gotmpl", "gowork", "python", "rust", "sql" },
        formatters_by_ft = {
            python = { lsp_format = "first", filter = FILTER_RUFF },
        },
        linters_by_ft = {
            sql = { "sqlfluff" },
        },
    },
    {
        name = "webdev",
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
        formatters_by_ft = {
            json = { "prettierd" },
            javascript = pb(),
            typescript = pb(),
            css = pb(),
            html = pb(),
            javascriptreact = pb(),
            typescriptreact = pb(),
            scss = pb(),
            less = pb(),
            vue = pb(),
            svelte = pb(),
            graphql = pb(),
        },
        linters_by_ft = {
            json = { "jsonlint" },
            javascript = { "eslint_d" },
            javascriptreact = { "eslint_d" },
            typescript = { "eslint_d" },
            typescriptreact = { "eslint_d" },
            css = { "stylelint" },
            scss = { "stylelint" },
        },
    },
    {
        name = "docs",
        lsp = { "marksman", "texlab", "tinymist" },
        treesitter = { "latex", "markdown", "markdown_inline", "mermaid", "typst" },
        formatters_by_ft = {
            markdown = { "prettierd" },
            tex = { "latexindent" },
            typst = { lsp_format = "first", filter = FILTER_TINY_MIST },
        },
        linters_by_ft = {
            markdown = { "markdownlint" },
        },
    },
    {
        name = "shell",
        lsp = { "bashls", "fish_lsp" },
        treesitter = { "bash", "fish", "zsh" },
        formatters_by_ft = {
            sh = { "shfmt" },
            bash = { "shfmt" },
            zsh = { "beautysh" },
            fish = { "fish_indent" },
        },
        linters_by_ft = {
            sh = { "shellcheck" },
            bash = { "shellcheck" },
            zsh = { "shellcheck" },
            fish = { "fish" },
        },
    },
    {
        name = "infra",
        lsp = {
            { name = "jsonls", settings = jsonls_settings },
            { name = "nixd", settings = nixd_settings },
            "taplo",
            { name = "yamlls", settings = yamlls_settings },
        },
        treesitter = { "dockerfile", "ini", "make", "meson", "nginx", "ninja", "nix", "toml", "yaml" },
        formatters_by_ft = {
            yaml = { "prettierd" },
            nix = { "nixfmt" },
        },
        linters_by_ft = {
            nix = { "statix" },
            yaml = { "yamllint" },
        },
    },
    {
        name = "git",
        treesitter = { "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore" },
        linters_by_ft = {
            gitcommit = { "commitlint", "gitlint" },
        },
    },
    {
        name = "core",
        lsp = { "lua_ls" },
        treesitter = { "lua", "regex", "vim", "vimdoc" },
        formatters_by_ft = {
            lua = { "stylua" },
        },
    },
}

M.skip_install = { "nixfmt", "nixd", "fish_indent", "fish", "statix" }

return M
