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
        opts = function(_, opts)
            -- This extends the default adapters configuration
            opts.adapters = vim.tbl_deep_extend("force", opts.adapters or {}, {
                ["neotest-jest"] = {
                    jestCommand = "npm test --",
                    jestConfigFile = function(file)
                        if string.find(file, "/packages/") then
                            local package_path = string.match(file, "(.-packages/[^/]+/)")
                            if package_path then
                                return package_path .. "jest.config.ts"
                            end
                        end
                        return vim.fn.getcwd() .. "/jest.config.ts"
                    end,
                    cwd = function(file)
                        if string.find(file, "/packages/") then
                            local package_path = string.match(file, "(.-/packages/[^/]+/)")
                            if package_path then
                                return package_path
                            end
                        end
                        return vim.fn.getcwd()
                    end,
                    env = { CI = true },
                },
            })
        end,
        -- opts = {
        --     adapters = {
        --         ["neotest-jest"] = true,
        --     },
        -- },
        -- config = function()
        --     require("neotest").setup({
        --         adapters = {
        --             require("neotest-jest")({
        --                 jestCommand = "npm test --",
        --                 jestConfigFile = function(file)
        --                     if string.find(file, "/packages/") then
        --                         local package_path = string.match(file, "(.-packages/[^/]+/)")
        --                         if package_path then
        --                             vim.print(package_path)
        --                             return package_path .. "jest.config.ts"
        --                         end
        --                         -- return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
        --                     end
        --                     return vim.fn.getcwd() .. "/jest.config.ts"
        --                 end,
        --                 cwd = function(file)
        --                     if string.find(file, "/packages/") then
        --                         local package_path = string.match(file, "(.-/packages/[^/]+/)")
        --                         if package_path then
        --                             return package_path
        --                         end
        --                         -- return string.match(file, "(.-/[^/]+/)src")
        --                     end
        --                     return vim.fn.getcwd()
        --                 end,
        --                 env = { CI = true },
        --             }),
        --         },
        --     })
        -- end,
    },
}
