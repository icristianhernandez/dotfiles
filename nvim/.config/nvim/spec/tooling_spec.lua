-- To run that unit test:
-- nvim --headless -u nvim/.config/nvim/init.lua -c "lua require('plenary.busted').run('nvim/.config/nvim/spec/tooling_spec.lua')" -c "qa"
local eq = assert.are.same
local tooling = require("modules.extras.tooling")

describe("tooling resolver", function()
    it("normalizes string entries and defaults", function()
        local stacks = {
            s = {
                lsps = { "foo" },
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
        for _, n in ipairs(mn) do
            if n == "prettierd" then has_prettierd = true end
            if n == "stylua" then has_stylua = true end
            if n == "nixfmt" then has_nixfmt = true end
        end
        assert.is_true(has_prettierd and has_stylua and has_nixfmt)
    end)

end)
