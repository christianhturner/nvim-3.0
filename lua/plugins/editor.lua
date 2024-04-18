return {
    -- Auto-Save
    --[[
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup()
        end,
    },
    ]]
    -- Whichkey Top Level Menus
    {
        "folke/which-key.nvim",
        opts = {
            defaults = {
                ["<leader>r"] = { name = "+Refactor" },
            },
        },
    },
    -- VIM APM
    {
        "ThePrimeagen/vim-apm",
        opts = {},
        config = function(_, opts)
            local apm = require("vim-apm")
            apm:setup({})
            vim.keymap.set("n", "<leader>apm", function()
                apm:toggle_monitor()
            end)
        end,
    },
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
