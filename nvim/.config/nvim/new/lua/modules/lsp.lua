-- LSP servers and diagnostics configuration
return {
    -- neovim/nvim-lspconfig: configure LSP servers, diagnostics and root detection
    {
        "neovim/nvim-lspconfig",
        opts = {
            diagnostics = {
                virtual_text = false,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.HINT] = "",
                    },
                    numhl = {
                        [vim.diagnostic.severity.WARN] = "WarningMsg",
                        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
                        [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
                        [vim.diagnostic.severity.HINT] = "DiagnosticHint",
                    },
                },
            },
            servers = {
                html = {},
                cssls = {},
                biome = {
                    root_dir = function(fname)
                        local lsp_util = require("lspconfig.util")
                        local root_files = { "biome.json", "biome.jsonc" }
                        local biome_package_config_files = lsp_util.insert_package_json(root_files, "biome", fname)
                        local found_root = lsp_util.root_pattern(unpack(biome_package_config_files))(fname)
                        if found_root then
                            return found_root
                        end
                        local biome_dependency_root = lsp_util.insert_package_json({}, "@biomejs/biome", fname)
                        return lsp_util.root_pattern(unpack(biome_dependency_root))(fname)
                    end,
                },
                denols = {
                    root_dir = function(fname)
                        local lsp_util = require("lspconfig.util")
                        return lsp_util.root_pattern("deno.json", "deno.jsonc", "deno.lock")(fname)
                    end,
                },
                ts_ls = {
                    root_dir = function(fname)
                        local lsp_util = require("lspconfig.util")
                        if lsp_util.root_pattern("deno.json", "deno.jsonc", "deno.lock")(fname) then
                            return nil
                        else
                            return lsp_util.root_pattern("package.json")(fname)
                        end
                    end,
                    single_file_support = false,
                },
                nixd = {
                    settings = {
                        nixd = {
                            nixpkgs = {
                                expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }",
                            },
                            formatting = {
                                command = { "nixfmt" },
                            },
                            options = {
                                nixos = {
                                    expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nixos.options",
                                },
                                ["home-manager"] = {
                                    expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nixos.options.home-manager.users.type.getSubOptions []",
                                },
                            },
                        },
                    },
                    root_dir = function(fname)
                        local lsp_util = require("lspconfig.util")
                        return lsp_util.root_pattern("flake.nix", "flake.lock", "default.nix", "shell.nix", ".git")(
                            fname
                        )
                    end,
                },
            },
        },
    },
}
