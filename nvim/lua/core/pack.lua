local M = {}

M.plugin_configs = {}

--- Add or merge configuration for a plugin.
--- @param name string Plugin name as used in the registry.
--- @param new_opts table Options to merge into the existing configuration.
function M.add_config(name, new_opts)
    M.plugin_configs[name] = vim.tbl_deep_extend("force", M.plugin_configs[name] or {}, new_opts)
end

--- Get the configuration for a plugin.
--- @param name string Plugin name.
--- @param default_opts? table Optional default options if none are found in the registry.
--- @return table The merged configuration.
function M.get_config(name, default_opts)
    return vim.tbl_deep_extend("force", default_opts or {}, M.plugin_configs[name] or {})
end

--- Execute the setup for a plugin using the registry.
--- @param name string Plugin name in the registry.
--- @param module_name? string The actual Lua module to require (defaults to name).
--- @param default_opts? table Default options.
function M.setup(name, module_name, default_opts)
    local actual_module = module_name or name
    local opts = M.get_config(name, default_opts)
    require(actual_module).setup(opts)
end

--- Helper to load a plugin and its configuration only if it's installed.
--- @param spec string|table Plugin specification.
--- @param setup_fn function Function to execute for setup.
function M.add(spec, setup_fn)
    vim.pack.add({ spec })
    if setup_fn then
        setup_fn()
    end
end

return M
