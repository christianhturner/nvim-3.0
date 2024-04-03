return {
    --[[
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "mxsdev/nvim-dap-vscode-js",
            {
                "microsoft/vscode-js-debug",
                version = "1.x",
                build = "npm i && npm run compile vsDebugServerBundle && mv dis out",
            },
        },
        opts = function()
            for _, language in ipairs({ "svelte", "typescript", "javascript" }) do
                require("dap-vscode-js").setup({
                    debugger_path = vim.fn.stdpath("data")
                        .. "/lazy/vscode-js-debug",
                    adapters = {
                        "pwa-node",
                        "pwa-chrome",
                        "pwa-msedge",
                        "node-terminal",
                        "pwa-extensionHost",
                    },
                })
                require("dap").configurations[language] = {
                    -- attach to a node process that has been started with
                    -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
                    -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
                    {
                        -- use nvim-dap-vscode-js's pwa-node debug adapter
                        type = "pwa-node",
                        -- attach to an already running node process with --inspect flag
                        -- default port: 9222
                        request = "attach",
                        -- allows us to pick the process using a picker
                        processId = require("dap.utils").pick_process,
                        -- name of the debug action you have to select for this config
                        name = "Attach debugger to existing `node --inspect` process",
                        -- for compiled languages like TypeScript or Svelte.js
                        sourceMaps = true,
                        -- resolve source maps in nested locations while ignoring node_modules
                        resolveSourceMapLocations = {
                            "${workspaceFolder}/**",
                            "!**/node_modules/**",
                        },
                        -- path to src in vite based projects (and most other projects as well)
                        cwd = "${workspaceFolder}/src",
                        -- we don't want to debug code inside node_modules, so skip it!
                        skipFiles = {
                            "${workspaceFolder}/node_modules/**/*.js",
                        },
                    },
                    {
                        -- use nvim-dap-vscode-js's pwa-chrome debug adapter
                        type = "pwa-chrome",
                        request = "launch",
                        -- name of the debug action
                        name = "Launch Chrome to debug client side code",
                        -- default vite dev server url
                        url = "http://localhost:5173",
                        -- for TypeScript/Svelte
                        sourceMaps = true,
                        webRoot = "${workspaceFolder}/src",
                        protocol = "inspector",
                        port = 5174,
                        -- skip files from vite's hmr
                        skipFiles = {
                            "**/node_modules/**/*",
                            "**/@vite/*",
                            "**/src/client/*",
                            "**/src/*",
                        },
                    },
                    language == "javascript"
                            and {
                                -- use nvim-dap-vscode-js's pwa-node debug adapter
                                type = "pwa-node",
                                -- launch a new process to attach the debugger to
                                request = "launch",
                                -- name of the debug action you have to select for this config
                                name = "Launch file in new node process",
                                -- launch current file
                                program = "${file}",
                                cwd = "${workspaceFolder}",
                            }
                        or nil,
                }
            end
        end,
    },
    ]]
    --
}
