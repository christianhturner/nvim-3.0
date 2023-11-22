local Util = require("lazyvim.util")

return {
    -- Auto-Save
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup()
        end,
    },
    -- aerial
    {
        "stevearc/aerial.nvim",
        opts = { open_automatic = false },
    },
    -- arial - telescope
    {
        "nvim-telescope/telescope.nvim",
        opts = function()
            Util.on_load("telescope.nvim", function()
                require("telescope").load_extension("aerial")
            end)
        end,
    },
}
