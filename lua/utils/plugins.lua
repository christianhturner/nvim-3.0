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

    local function test() end

    -- Register the command
    vim.api.nvim_create_user_command("PrintLSPConfig", print_lsp_config, {})
end

return M
