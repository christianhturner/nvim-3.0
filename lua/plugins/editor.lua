return {
    -- {
    --     -- Icon Picker
    --     "ziontee113/icon-picker.nvim",
    --     config = function()
    --         require("icon-picker").setup({ disable_legacy_commands = true })
    --     end,
    --     keys = {
    --         {
    --             "<leader>i",
    --             "<cmd>IconPickerNormal<cr>",
    --             noremap = true,
    --             silent = true,
    --         },
    --         {
    --             "<leader>iy",
    --             "<cmd>IconPickerYank<cr>",
    --             noremap = true,
    --             silent = true,
    --         },
    --         {
    --             "<C-i>",
    --             "<cmd>IconPickerInsert<cr>",
    --             mode = "i",
    --             noremap = true,
    --             silent = true,
    --         },
    --     },
    -- },
    -- Whichkey Top Level Menus
    {
        "folke/which-key.nvim",
        opts = {
            defaults = {
                ["<leader>r"] = { name = "+Refactor" },
            },
        },
    },
    -- VIM APM Haven't found much use, will revist at a later date
    -- {
    --     "ThePrimeagen/vim-apm",
    --     opts = {},
    --     config = function(_, opts)
    --         local apm = require("vim-apm")
    --         apm:setup({})
    --         vim.keymap.set("n", "<leader>apm", function()
    --             apm:toggle_monitor()
    --         end)
    --     end,
    -- },
    -- OCTO - Github Plugin
    {
        "pwntester/octo.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("octo").setup()
        end,
    },
}
