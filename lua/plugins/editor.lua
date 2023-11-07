local Util = require("lazyvim.util")

return {
    -- arial
    {
        "stevearc/aerial.nvim",
        opts = { open_automatic = true },
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
    -- arial - edgy
    "folke/edgy.nvim",
    opts = function(_, opts)
        local edgy_idx = Util.plugin.extra_idx("ui.edgy")
        local aerial_idx = Util.plugin.extra_idx("editor.aerial")
        if edgy_idx and edgy_idx > aerial_idx then
            Util.warn(
                "The `edgy.nvim` extra must be **imported** before the `aerial.nvim` extra to work properly.",
                {
                    title = "LazyVim",
                }
            )
        end
        opts.right = opts.right or {}
        table.insert(opts.right, {
            title = "Aerial",
            ft = "aerial",
            pinned = true,
            open = "AerialOpen",
        })
    end,
    -- arial - lualine
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
        table.insert(opts.sections.lualine_c, {
            "aerial",
            sep = " ", -- separator between symbols
            sep_icon = "", -- separator between icon and symbol

            -- The number of symbols to render top-down. In order to render only 'N' last
            -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
            -- be used in order to render only current symbol.
            depth = 5,

            -- When 'dense' mode is on, icons are not rendered near their symbols. Only
            -- a single icon that represents the kind of current symbol is rendered at
            -- the beginning of status line.
            dense = false,

            -- The separator to be used to separate symbols in dense mode.
            dense_sep = ".",

            -- Color the symbol icons.
            colored = true,
        })
    end,
}
