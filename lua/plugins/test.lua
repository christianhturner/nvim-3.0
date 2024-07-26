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
            local jestConfig = {
                "jest.config.ts",
                "jest.config.js",
                "jest.config.mjs",
                "jest.config.cjs",
                "jest.config.json",
            }
            require("neotest").setup({
                adapters = {
                    require("neotest-jest")({
                        -- jestCommand = require("neotest-jest.jest-util").getJestCommand(vim.fn.expand "%:p:h"),
                        jestConfigFile = function(file)
                            local function findConfig(dir)
                                local packageName =
                                    string.match(dir, "([^/]+)/?$")
                                -- check for Amazon Stuff
                                if
                                    vim.fn.filereadable(dir .. "/packageInfo")
                                    == 1
                                then
                                    dir = dir .. "src/" .. packageName .. "/"
                                end
                                for _, configFile in ipairs(jestConfig) do
                                    local fullPath = dir .. configFile
                                    print(fullPath)
                                    if vim.fn.filereadable(fullPath) == 1 then
                                        return fullPath
                                    end
                                end
                                return nil
                            end

                            local configDir
                            if string.find(file, "/packages/") then
                                configDir = string.match(file, "(.-/[^/]+/)src")
                            else
                                configDir = vim.fn.getcwd()
                            end

                            local configPath = findConfig(configDir)
                            if configPath then
                                return configPath
                            else
                                error("No Jest config file found")
                            end
                        end,
                        -- if string.find(file, "/packages/") then
                        --     return string.match(file, "(.-/[^/]+/)src")
                        --         .. jestConfig
                        -- end
                        --
                        -- return vim.fn.getcwd() .. jestConfig
                        -- cwd = function(path)
                        --     if string.find(path, "/packages/") then
                        --         return string.match(path, "(.-/[^/]+/)src")
                        --     end
                        --     return vim.fn.getcwd()
                        -- end,
                    }),
                },
            })
        end,
    },
}
--     --[[
--     -- Jest
--     {
--         "David-Kunz/jester",
--         ft = {
--             "typescript",
--             "javascript",
--             "javascriptreact",
--             "typescriptreact",
--         },
--         keys = {
--             {
--                 "<leader>j",
--                 "",
--                 desc = "+Jest",
--             },
--             {
--                 "<leader>jn",
--                 '<cmd>require"jester".run()<cr>',
--                 desc = "Run Nearest test(s) under the cursor",
--             },
--             {
--                 "<leader>jc",
--                 '<cmd>require"jester".run_file()<cr>',
--                 desc = "Run current file",
--             },
--             {
--                 "<leader>jl",
--                 '<cmd>require"jester".run_last()<cr>',
--                 desc = "Run last test(s)",
--             },
--             {
--                 "<leader>jN",
--                 '<cmd>require"jester".debug()<cr>',
--                 desc = "Debug Nearest test(s) under the cursor",
--             },
--             {
--                 "<leader>jC",
--                 '<cmd>require"jester".debug_file()<cr>',
--                 desc = "Debug current file",
--             },
--             {
--                 "<leader>jL",
--                 '<cmd>require"jester".debug_last()<cr>',
--                 desc = "Debug last test(s)",
--             },
--         },
--     },
--     ]]
--     --
-- }
