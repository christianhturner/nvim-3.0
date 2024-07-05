-- local function registerLaunchJson()
--     vim.api.nvim_create_autocmd("VimEnter", {
--         once = true,
--         callback = function()
--             local rootDir = require("lazyvim.util.root").get()
--             local vscodeLaunch = ".vscode/launch.json"
--             if vim.uv.fs_stat(rootDir .. "/" .. vscodeLaunch) then
--                 require("dap.ext.vscode").load_launchjs()
--                 return vim.notify(
--                     "Loaded DAP configs from `.vscode/launch.json`."
--                 )
--             end
--             return vim.notify("No `.vscode/launch.json` file to source.")
--         end,
--     })
-- end

return {
    -- Task Runner | Overseer.nvim
    -- {
    --     "stevearc/overseer.nvim",
    --     dependencies = {
    --         "mfussenegger/nvim-dap",
    --         {
    --             "akinsho/toggleterm.nvim",
    --             config = function()
    --                 require("toggleterm").setup({})
    --             end,
    --         },
    --     },
    --     opts = {
    --         strategy = {
    --             "toggleterm",
    --             use_shell = true,
    --         },
    --     },
    --     config = function(_, opts)
    --         require("overseer").setup(opts)
    --         require("dap.ext.vscode").json_decode =
    --             require("overseer.json").decode
    --
    --         registerLaunchJson()
    --     end,
    -- },
    {
        "mistricky/codesnap.nvim",
        build = "make",
        keys = {
            {
                "<leader>cs",
                -- "<cmd>lua require('codesnap').copy_into_clipboard()<cr>",
                "<cmd>CodeSnap<cr>",
                mode = "x",
                desc = "Copy selected code to your clipboard.",
            },
            {
                "<leader>cS",
                "<cmd>CodeSnapSave<cr>",
                mode = "x",
                desc = "Save code screenshot to directory.",
            },
        },
        opts = {
            has_breadcrumbs = true,
            breadcrumbs_separator = " ==> ",
            watermark = "",
        },
        config = function(_, opts)
            local xdg_config = vim.env.XDG_CONFIG_HOME or vim.env.HOME
            local screenshot_dir = "Pictures/codesnap-screenshots"

            local function have()
                if not vim.uv.fs_stat(xdg_config .. "/" .. screenshot_dir) then
                    local new_dir = xdg_config .. "/" .. screenshot_dir
                    local success, err = vim.uv.fs_mkdir(new_dir, 493)
                    if not success then
                        error("Failed to create directory: " .. err)
                    end
                end
            end
            have()

            local codesnap_dir = xdg_config .. "/" .. screenshot_dir

            local options =
                vim.tbl_extend("force", opts, { save_path = codesnap_dir })

            require("codesnap").setup(options)
        end,
    },
}
