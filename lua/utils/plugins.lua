local M = {}

M.setup = function()
    -- Function to print LSP config
    local function print_lsp_config()
        local configs = vim.lsp.get_clients()
        if #configs == 0 then
            print("No active LSP clients found.")
            return
        end
        for i, config in ipairs(configs) do
            print(string.format("LSP %d: %s", i, config.name))
            print(vim.inspect(config.config))
            print("\n") -- Add a newline between configs for readability
        end
    end

    local function print_plugin_config()
        local plugins = require("lazy.core.config").plugins

        local plugin_names = {}
        for name, _ in pairs(plugins) do
            table.insert(plugin_names, name)
        end

        table.sort(plugin_names)

        vim.ui.select(plugin_names, {
            prompt = "Select a plugin to view its configration:",
            format_item = function(item)
                return item
            end,
        }, function(selected)
            if not selected then
                return
            end

            local plugin_config = plugins[selected]

            vim.cmd("vnew")
            local buf = vim.api.nvim_get_current_buf()

            vim.api.nvim_buf_set_name(buf, "plugin-config://" .. selected)

            local lines = { "-- Configuration for plugin: " .. selected, "" }

            local config_dump = vim.inspect(plugin_config)
            local config_lines = vim.split(config_dump, "\n")

            for _, line in ipairs(config_lines) do
                table.insert(lines, line)
            end

            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

            vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
            vim.api.nvim_set_option_value("filetype", "lua", { buf = buf })
        end)
    end

    -- Register the commands
    vim.api.nvim_create_user_command("PrintPluginConfig", print_plugin_config, {})
    vim.api.nvim_create_user_command("PrintLSPConfig", print_lsp_config, {})
end

return M
