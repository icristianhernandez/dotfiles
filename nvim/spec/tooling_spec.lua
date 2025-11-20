-- To run that unit test:
-- nvim --headless -u nvim/init.lua -c "lua require('plenary.busted').run('nvim/spec/tooling_spec.lua')" -c "qa"
local eq = assert.are.same
local tooling = require("modules.extras.tooling")

describe("tooling resolver", function()
    it("normalizes string entries and defaults", function()
        local stacks = {
            s = {
                lsps = { "foo" },
                parsers = { "foo" },
                formatters_by_ft = { lua = { "bar" } },
                linters = { "baz" },
            },
        }

        local out = tooling.build(stacks)

        eq({ "foo" }, out.mason_lspconfig.ensure_installed)
        eq({ "foo" }, out.mason_lspconfig.automatic_enable)
        eq({ lua = { "bar" } }, out.conform.formatters_by_ft)
        eq({ "bar", "baz" }, out.mason_null_ls.ensure_installed)
        eq({}, out.null_ls.init)
        eq({ "foo" }, out.treesitter.ensure_installed)
    end)

    it("normalizes parser strings and defaults", function()
        local stacks = {
            s = {
                parsers = { "baz" },
            },
        }

        local out = tooling.build(stacks)
        eq({ "baz" }, out.treesitter.ensure_installed)
    end)

    it("respects install=false and enable flags", function()
        local stacks = {
            s = {
                lsps = {
                    { name = "noinst", install = false, enable = true },
                    { name = "noenable", install = true, enable = false },
                },
                linters = {
                    { name = "nolint", installation = false, methods = { "diagnostics" } },
                    { name = "l2", install = true },
                },
            },
        }

        local out = tooling.build(stacks)

        -- noinst is enabled but not installed
        eq({}, out.mason_lspconfig.ensure_installed)
        eq({ "noinst" }, out.mason_lspconfig.automatic_enable)

        -- noenable is install=true but enable=false so not present
        -- ensure_installed should not include noenable because enable=false

        -- linters: l2 should be in mason_null_ls, nolint should appear in null_ls.init
        eq({ "l2" }, out.mason_null_ls.ensure_installed)
        eq(1, #out.null_ls.init)
        eq({ method = "diagnostics", name = "nolint" }, out.null_ls.init[1])
    end)

    it("handles formatter entries as tables and strings, and multiple fts", function()
        local stacks = {
            s = {
                formatters_by_ft = {
                    lua = { "stylua" },
                    javascript = { "prettierd", { name = "esfmt", install = false } },
                },
            },
        }

        local out = tooling.build(stacks)

        eq({ lua = { "stylua" }, javascript = { "prettierd", "esfmt" } }, out.conform.formatters_by_ft)
        -- mason_null_ls should include only prettierd and stylua (esfmt install=false so not included)
        table.sort(out.mason_null_ls.ensure_installed)
        eq({ "prettierd", "stylua" }, out.mason_null_ls.ensure_installed)
    end)

    it("supports method singular/plural fields for linters", function()
        local stacks = {
            s = {
                linters = {
                    { name = "fish", method = "diagnostics", installation = false },
                    { name = "shellcheck", methods = { "diagnostics" }, installation = false },
                },
            },
        }

        local out = tooling.build(stacks)

        -- both should be in null_ls.init with diagnostics
        -- order is preserved as inserted
        eq(2, #out.null_ls.init)
        eq({ method = "diagnostics", name = "fish" }, out.null_ls.init[1])
        eq({ method = "diagnostics", name = "shellcheck" }, out.null_ls.init[2])
    end)

    it("empty stacks produces empty outputs", function()
        local out = tooling.build({})
        eq({}, out.mason_lspconfig.ensure_installed)
        eq({}, out.mason_lspconfig.automatic_enable)
        eq({}, out.conform.formatters_by_ft)
        eq({}, out.mason_null_ls.ensure_installed)
        eq({}, out.null_ls.init)
    end)

    it("preserves defaults for missing fields", function()
        local stacks = {
            s = {
                lsps = { { "onlyname" } },
                formatters_by_ft = { lua = { { "fmt1" } } },
            },
        }

        local out = tooling.build(stacks)
        eq({ "onlyname" }, out.mason_lspconfig.ensure_installed)
        eq({ "onlyname" }, out.mason_lspconfig.automatic_enable)
        eq({ lua = { "fmt1" } }, out.conform.formatters_by_ft)
        eq({ "fmt1" }, out.mason_null_ls.ensure_installed)
    end)

    it("current in-use stacks resolve correctly", function()
        local stacks = {
            lua = {
                lsps = { "lua_ls" },
                formatters_by_ft = { lua = { "stylua" } },
            },
            web_dev = {
                lsps = { "vtsls", "eslint" },
                formatters_by_ft = {
                    javascript = { "prettierd" },
                    markdown = { "prettierd" },
                },
            },
            nix = {
                lsps = { { name = "nixd", install = false, enable = true } },
                formatters_by_ft = { nix = { "nixfmt" } },
                linters = { "statix" },
            },
            dotfiles = {
                linters = { { method = "diagnostics", name = "fish", installation = false } },
            },
        }

        local out = tooling.build(stacks)

        -- mason_lspconfig.ensure_installed should include lua_ls, vtsls, eslint (nixd has install=false)
        eq({ "eslint", "lua_ls", "vtsls" }, out.mason_lspconfig.ensure_installed)

        -- automatic_enable should include all enabled LSPs including nixd
        eq({ "eslint", "lua_ls", "nixd", "vtsls" }, out.mason_lspconfig.automatic_enable)

        -- representative formatters present
        assert.is_truthy(out.conform.formatters_by_ft.lua)
        eq({ "stylua" }, out.conform.formatters_by_ft.lua)
        assert.is_truthy(out.conform.formatters_by_ft.javascript)
        assert.is_truthy(out.conform.formatters_by_ft.markdown)
        assert.is_truthy(out.conform.formatters_by_ft.nix)
        eq({ "nixfmt" }, out.conform.formatters_by_ft.nix)

        -- mason_null_ls should include prettierd, stylua, nixfmt, statix (fish installation=false)
        table.sort(out.mason_null_ls.ensure_installed)
        eq({ "nixfmt", "prettierd", "statix", "stylua" }, out.mason_null_ls.ensure_installed)

        -- null_ls.init should contain fish diagnostic registration
        assert.is_true(#out.null_ls.init >= 1)
        local found = false
        for _, v in ipairs(out.null_ls.init) do
            if v.method == "diagnostics" and v.name == "fish" then
                found = true
                break
            end
        end
        assert.is_true(found)
    end)

    -- New tests added:
    it("supports lsp installation alias field (installation)", function()
        local stacks = {
            s = {
                lsps = { { name = "aliaslsp", installation = false, enable = true } },
            },
        }

        local out = tooling.build(stacks)

        -- installation=false should prevent inclusion in ensure_installed but enable=true keeps it in automatic_enable
        eq({}, out.mason_lspconfig.ensure_installed)
        eq({ "aliaslsp" }, out.mason_lspconfig.automatic_enable)
    end)

    it("ignores linters with install=false and no methods", function()
        local stacks = {
            s = {
                linters = { { name = "nolints", installation = false } },
            },
        }

        local out = tooling.build(stacks)

        -- nolints should not be installed nor registered in null_ls.init
        eq({}, out.mason_null_ls.ensure_installed)
        eq(0, #out.null_ls.init)
    end)

    it("dedupes mason sets but preserves formatter duplicates", function()
        local stacks = {
            s = {
                formatters_by_ft = { lua = { "stylua", "stylua" } },
                linters = { "statix", "statix" },
            },
        }

        local out = tooling.build(stacks)

        -- formatters_by_ft should preserve duplicates in order
        eq(2, #out.conform.formatters_by_ft.lua)
        eq({ "stylua", "stylua" }, out.conform.formatters_by_ft.lua)

        -- mason_null_ls should dedupe entries; sort before comparing
        table.sort(out.mason_null_ls.ensure_installed)
        eq({ "statix", "stylua" }, out.mason_null_ls.ensure_installed)
    end)

    -- Verify the repository stacks directly: ensure Conform options
    it("resolves repo stacks preserving conform options and formatters", function()
        local stacks = require("modules.extras.tooling").stacks
        local out = tooling.build(stacks)

        -- Ensure conform per-ft options preserved for javascript
        assert.is_truthy(out.conform.formatters_by_ft.javascript)
        assert.is_truthy(out.conform.formatters_by_ft.javascript.stop_after_first ~= nil)
        assert.is_truthy(out.conform.formatters_by_ft.javascript.lsp_format ~= nil)
        assert.is_truthy(type(out.conform.formatters_by_ft.javascript.filter) == "function")

        -- Numeric formatter entries preserved and are strings
        assert.is_truthy(#out.conform.formatters_by_ft.javascript >= 1)
        for _, v in ipairs(out.conform.formatters_by_ft.javascript) do
            assert.is_true(type(v) == "string")
        end

        -- Mason sets include representative installers
        local mn = out.mason_null_ls.ensure_installed
        table.sort(mn)
        local has_prettierd = false
        local has_stylua = false
        local has_nixfmt = false
        local has_commitlint = false
        local has_gitlint = false
        for _, n in ipairs(mn) do
            if n == "prettierd" then
                has_prettierd = true
            end
            if n == "stylua" then
                has_stylua = true
            end
            if n == "nixfmt" then
                has_nixfmt = true
            end
            if n == "commitlint" then
                has_commitlint = true
            end
            if n == "gitlint" then
                has_gitlint = true
            end
        end
        assert.is_true(has_prettierd and has_stylua and not has_nixfmt and has_commitlint and has_gitlint)
    end)

    it("resolves repo stacks parsers include representative parsers", function()
        local stacks = require("modules.extras.tooling").stacks
        local out = tooling.build(stacks)
        local has_lua = false
        local has_js = false
        local has_python = false
        local has_nix = false
        local has_json = false
        local has_gitignore = false
        local has_vim = false
        local has_dockerfile = false
        local has_go = false
        local has_rust = false

        for _, n in ipairs(out.treesitter.ensure_installed) do
            if n == "lua" then
                has_lua = true
            end
            if n == "javascript" then
                has_js = true
            end
            if n == "python" then
                has_python = true
            end
            if n == "nix" then
                has_nix = true
            end
            if n == "json" then
                has_json = true
            end
            if n == "gitignore" then
                has_gitignore = true
            end
            if n == "vim" then
                has_vim = true
            end
            if n == "dockerfile" then
                has_dockerfile = true
            end
            if n == "go" then
                has_go = true
            end
            if n == "rust" then
                has_rust = true
            end
        end
        assert.is_true(
            has_lua
                and has_js
                and has_python
                and has_nix
                and has_json
                and has_gitignore
                and has_vim
                and has_dockerfile
                and has_go
                and has_rust
        )
    end)

    it("respects parser install=false and installation alias", function()
        local stacks = {
            s = {
                parsers = {
                    { name = "noinst", install = false },
                    { name = "aliasp", installation = false },
                    "installme",
                },
            },
        }

        local out = tooling.build(stacks)
        eq({ "installme" }, out.treesitter.ensure_installed)
    end)

    it("dedupes parser names across stacks", function()
        local stacks = {
            a = { parsers = { "bash", "bash" } },
            b = { parsers = { "bash" } },
        }
        local out = tooling.build(stacks)
        eq({ "bash" }, out.treesitter.ensure_installed)
    end)
    it("errors when same filetype defined in multiple stacks", function()
        local stacks = {
            a = { formatters_by_ft = { lua = { "stylua" } } },
            b = { formatters_by_ft = { lua = { "anotherfmt" } } },
        }
        assert.has_error(function()
            tooling.build(stacks)
        end)
    end)

    it("excludes lsp with install=false and enable=false", function()
        local stacks = { s = { lsps = { { name = "x", install = false, enable = false } } } }
        local out = tooling.build(stacks)
        eq({}, out.mason_lspconfig.ensure_installed)
        eq({}, out.mason_lspconfig.automatic_enable)
    end)

    it("dedupes lsp names across stacks", function()
        local stacks = {
            a = { lsps = { "lua_ls", "lua_ls" } },
            b = { lsps = { "lua_ls" } },
        }
        local out = tooling.build(stacks)
        eq({ "lua_ls" }, out.mason_lspconfig.ensure_installed)
        eq({ "lua_ls" }, out.mason_lspconfig.automatic_enable)
    end)

    it("install=true linters with methods do not populate null_ls.init", function()
        local stacks = { s = { linters = { { name = "eslint_d", install = true, methods = { "diagnostics" } } } } }
        local out = tooling.build(stacks)
        eq({ "eslint_d" }, out.mason_null_ls.ensure_installed)
        eq(0, #out.null_ls.init)
    end)

    it("install=false linters with multiple methods populate null_ls.init in order", function()
        local stacks = {
            s = { linters = { { name = "fish", installation = false, methods = { "diagnostics", "code_actions" } } } },
        }
        local out = tooling.build(stacks)
        eq(2, #out.null_ls.init)
        eq({ method = "diagnostics", name = "fish" }, out.null_ls.init[1])
        eq({ method = "code_actions", name = "fish" }, out.null_ls.init[2])
    end)

    it("respects formatter installation alias field", function()
        local stacks = { s = { formatters_by_ft = { lua = { { name = "stylua", installation = false } } } } }
        local out = tooling.build(stacks)
        eq({ lua = { "stylua" } }, out.conform.formatters_by_ft)
        eq({}, out.mason_null_ls.ensure_installed)
    end)

    it("errors on invalid formatter numeric entry type", function()
        local stacks = { s = { formatters_by_ft = { lua = { 123 } } } }
        assert.has_error(function()
            tooling.build(stacks)
        end)
    end)

    it("errors on malformed entries missing names (lsp/formatter/linter)", function()
        local bads = {
            { s = { lsps = { {} } } },
            { s = { formatters_by_ft = { lua = { {} } } } },
            { s = { linters = { {} } } },
        }
        for _, st in ipairs(bads) do
            assert.has_error(function()
                tooling.build(st)
            end)
        end
    end)

    it("repo web_dev conform filter returns true only for biome", function()
        local stacks = require("modules.extras.tooling").stacks
        local out = tooling.build(stacks)
        -- pick javascript entry for options
        local filter = out.conform.formatters_by_ft.javascript.filter
        assert.is_truthy(type(filter) == "function")
        assert.is_true(filter({ name = "biome" }))
        assert.is_true(not filter({ name = "prettierd" }))
        assert.is_true(not filter({ name = "eslint" }))
    end)

    it("per-filetype conform entries are distinct tables", function()
        local stacks = require("modules.extras.tooling").stacks
        local out = tooling.build(stacks)
        local js = out.conform.formatters_by_ft.javascript
        local ts = out.conform.formatters_by_ft.typescript
        assert.is_truthy(js)
        assert.is_truthy(ts)
        assert.is_true(js ~= ts)
    end)

    -- Strict validation and edge-case tests
    it("errors on non-string numeric lsp/formatter/linter names", function()
        assert.has_error(function()
            tooling.build({ s = { lsps = { { name = 123 } } } })
        end)
        assert.has_error(function()
            tooling.build({ s = { formatters_by_ft = { lua = { { name = 123 } } } } })
        end)
        assert.has_error(function()
            tooling.build({ s = { linters = { { name = 123 } } } })
        end)
    end)

    it("errors on empty or whitespace-only names", function()
        assert.has_error(function()
            tooling.build({ s = { lsps = { { name = "" } } } })
        end)
        assert.has_error(function()
            tooling.build({ s = { formatters_by_ft = { lua = { { " " } } } } })
        end)
    end)

    it("errors when linter methods field has incorrect type", function()
        -- methods must be a table when provided; method must be a string when provided
        assert.has_error(function()
            tooling.build({ s = { linters = { { name = "x", installation = false, methods = "diag" } } } })
        end)
        assert.has_error(function()
            tooling.build({ s = { linters = { { name = "x", installation = false, method = 123 } } } })
        end)
    end)

    it("preserves unknown per-filetype option keys unchanged", function()
        local stacks = {
            s = {
                formatters_by_ft = {
                    lua = { { "stylua" }, stop_after_first = "yes", foo = 42 },
                },
            },
        }
        local out = tooling.build(stacks)
        eq("yes", out.conform.formatters_by_ft.lua.stop_after_first)
        eq(42, out.conform.formatters_by_ft.lua.foo)
    end)

    it("mutating one per-ft table does not affect others", function()
        local stacks = {
            s = {
                formatters_by_ft = {
                    a = { { "fmt1" } },
                    b = { { "fmt1" } },
                },
            },
        }
        local out = tooling.build(stacks)
        local a = out.conform.formatters_by_ft.a
        local b = out.conform.formatters_by_ft.b
        assert.is_true(a ~= b)
        a.extra = true
        assert.is_nil(b.extra)
    end)

    it("handles large duplicate sets and preserves dedupe for mason lists", function()
        local many = {}
        for i = 1, 20 do
            table.insert(many, "dupname")
        end
        local stacks = {
            s = {
                lsps = many,
                formatters_by_ft = { lua = many },
                linters = many,
            },
        }
        local out = tooling.build(stacks)
        -- mason lists dedup; ensure_installed should contain only one 'dupname'
        table.sort(out.mason_lspconfig.ensure_installed)
        eq({ "dupname" }, out.mason_lspconfig.ensure_installed)
        -- formatters_by_ft should preserve duplicates
        eq(20, #out.conform.formatters_by_ft.lua)
    end)

    it("ignores unknown keys on normalization but preserves per-ft options", function()
        local stacks = {
            s = {
                lsps = { { name = "withfoo", foo = 123 } },
                formatters_by_ft = { lua = { { name = "stylua", foo = 456 } } },
            },
        }
        local out = tooling.build(stacks)
        -- foo should not appear in mason lists (normalization ignores unknowns),
        -- but per-ft options copied should contain foo where present
        eq({ "withfoo" }, out.mason_lspconfig.ensure_installed)
        assert.is_nil(out.mason_lspconfig.foo)
        assert.is_truthy(out.conform.formatters_by_ft.lua.foo == 456)
    end)

    it("exposes per-LSP server configs", function()
        local cfg = { settings = { yaml = { schemas = { kubernetes = "*.yaml" } } } }
        local stacks = { a = { lsps = { { name = "yamlls", config = cfg } } } }
        local out = tooling.build(stacks)
        eq(cfg, out.mason_lspconfig.configs.yamlls)
    end)

    it("errors on duplicate lsp configs across stacks", function()
        local stacks = {
            a = { lsps = { { name = "yamlls", config = { a = 1 } } } },
            b = { lsps = { { name = "yamlls", config = { b = 2 } } } },
        }
        assert.has_error(function()
            tooling.build(stacks)
        end)
    end)

    it("repo stacks include manual null-ls code_action entries for gitrebase and gitsigns", function()
        local stacks = require("modules.extras.tooling").stacks
        local out = tooling.build(stacks)
        local found_gitsigns = false
        local found_gitrebase = false
        for _, v in ipairs(out.null_ls.init) do
            if v.method == "code_actions" and v.name == "gitsigns" then
                found_gitsigns = true
            end
            if v.method == "code_actions" and v.name == "gitrebase" then
                found_gitrebase = true
            end
        end
        assert.is_true(found_gitsigns and found_gitrebase)
        -- Ensure they are not part of mason_null_ls.ensure_installed set (install=false)
        for _, n in ipairs(out.mason_null_ls.ensure_installed) do
            assert.is_true(n ~= "gitsigns")
            assert.is_true(n ~= "gitrebase")
        end
    end)
end)
