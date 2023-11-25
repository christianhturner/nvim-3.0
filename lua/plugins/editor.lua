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
        optional = true,
        opts = {
            defaults = {
                ["<leader>r"] = { name = "+refactor" },
                ["<leader>h"] = { name = "+harpoon" },
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
        keys = {
            -- { "KeyCommand goes here", "<cmd>Whatever you'd trigger<cr>, desc = "What Which key shows"}
        },
    },
}
