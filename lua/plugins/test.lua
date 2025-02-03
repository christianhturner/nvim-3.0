---@diagnostic disable: missing-fields
return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            { "nvim-neotest/neotest-jest" },
        },
        ft = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
        },
        opts = {
            adapters = {
                ["neotest-jest"] = true,
            },
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-jest")({
                        jestCommand = "npm test --",
                        jestConfigFile = function(file)
                            if string.find(file, "/packages/") then
                                local package_path = string.match(file, "(.-packages/[^/]+/)")
                                if package_path then
                                    vim.print(package_path)
                                    return package_path .. "jest.config.ts"
                                end
                                -- return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
                            end
                            return vim.fn.getcwd() .. "/jest.config.ts"
                        end,
                        cwd = function(file)
                            if string.find(file, "/packages/") then
                                local package_path = string.match(file, "(.-/packages/[^/]+/)")
                                if package_path then
                                    return package_path
                                end
                                -- return string.match(file, "(.-/[^/]+/)src")
                            end
                            return vim.fn.getcwd()
                        end,
                        env = { CI = true },
                    }),
                },
                -- adapters = {
                --     require("neotest-jest")({
                --         -- jestCommand = require("neotest-jest.jest-util").getJestCommand(vim.fn.expand "%:p:h"),
                --         jestConfigFile = function(file)
                --             local function findConfig(dir)
                --                 local packageName = string.match(dir, "([^/]+)/?$")
                --                 -- check for Amazon Stuff
                --                 if vim.fn.filereadable(dir .. "/packageInfo") == 1 then
                --                     dir = dir .. "src/" .. packageName .. "/"
                --                 end
                --                 for _, configFile in ipairs(jestConfig) do
                --                     local fullPath = dir .. configFile
                --                     print(fullPath)
                --                     if vim.fn.filereadable(fullPath) == 1 then
                --                         return fullPath
                --                     end
                --                 end
                --                 return nil
                --             end
                --
                --             local configDir
                --             if string.find(file, "/packages/") then
                --                 configDir = string.match(file, "(.-/[^/]+/)src")
                --             else
                --                 configDir = vim.fn.getcwd()
                --             end
                --
                --             local configPath = findConfig(configDir)
                --             if configPath then
                --                 return configPath
                --             else
                --                 error("No Jest config file found")
                --             end
                --         end,
                --     }),
                -- },
            })
        end,
    },
}
