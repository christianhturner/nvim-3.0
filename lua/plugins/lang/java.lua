return {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
        local dap = require("dap")
        table.insert(dap.configurations.java, {
            type = "java",
            request = "attach",
            name = "Debug (Attach) - Specify port",
            hostName = "127.0.0.1",
            port = function()
                local port = vim.fn.input("Port: ", "8080")
                local port_num = tonumber(port)
                if port_num and port_num > 0 and port_num <= 65535 then
                    return port_num
                else
                    vim.notify("Invalid port number. Trying on default 8080.", vim.log.levels.WARN)
                    return 8080
                end
            end,
        })
    end,
}
