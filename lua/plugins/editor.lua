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
                ["<leader>h"] = { name = "+Harpoon" },
            },
        },
    },
    -- Harpoon
    {
        "ThePrimeagen/harpoon",
        config = function()
            require("harpoon").setup({
                menu = {
                    width = vim.api.nvim_win_get_width(0) - 4,
                },
            })
        end,
        event = "BufReadPre",
        keys = {
            {
                "<leader>hh",
                function()
                    require("harpoon.ui").toggle_quick_menu()
                end,
                desc = "Toggle Menu",
            },
            {
                "<leader>hm",
                function()
                    require("harpoon.mark").add_file()
                end,
                desc = "Mark File",
            },
            {
                "<leader>hr",
                function()
                    require("harpoon.mark").rm_file()
                end,
                desc = "Remove Mark",
            },
            {
                "<leader>ha",
                function()
                    require("harpoon.ui").nav_file(1)
                end,
                desc = "file a",
            },
            {
                "<leader>hs",
                function()
                    require("harpoon.ui").nav_file(2)
                end,
                desc = "file s",
            },
            {
                "<leader>hd",
                function()
                    require("harpoon.ui").nav_file(3)
                end,
                desc = "file d",
            },
            {
                "<leader>hf",
                function()
                    require("harpoon.ui").nav_file(4)
                end,
                desc = "file f",
            },
            {
                "<leader>hg",
                function()
                    require("harpoon.ui").nav_file(5)
                end,
                desc = "file g",
            },
            {
                "<leader>h.",
                function()
                    require("harpoon.ui").nav_next()
                end,
                desc = "next file",
            },
            {
                "<leader>h,",
                function()
                    require("harpoon.ui").nav_prev()
                end,
                desc = "prev file",
            },
        },
    },
}
