-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local del = vim.keymap.del

del("n", "<leader>l")

-- Load UI module for Amazon Q safely
local ui_loaded, ui = pcall(require, "ui")

local wk = require("which-key")

wk.add({
    { "<leader>l", group = "Lazy & Plugin Utils" },
    { "<leader>ll", "<cmd>Lazy<cr>", desc = "Lazy" },
    { "<leader>lp", "<cmd>PrintLSPConfig<cr>", desc = "LSP Print Config" },
    { "<leader>lc", "<cmd>PrintPluginConfig<cr>", desc = "Print Plugin Config - Select" },
})

-- Amazon Q keybinding
wk.add({
    { "<leader>a", group = "Amazon Tools" },
    { "<leader>aq", function() 
        -- Ensure UI module is loaded
        if ui_loaded then
            -- If terminal is hidden, show it; otherwise toggle
            if ui.terminal_hidden and ui.terminal_buf and vim.api.nvim_buf_is_valid(ui.terminal_buf) then
                ui.show_amazonq()
            else
                ui.toggle_amazonq()
            end
        else
            -- Try to load UI module again
            local success, loaded_ui = pcall(require, "ui")
            if success then
                if loaded_ui.terminal_hidden and loaded_ui.terminal_buf and vim.api.nvim_buf_is_valid(loaded_ui.terminal_buf) then
                    loaded_ui.show_amazonq()
                else
                    loaded_ui.toggle_amazonq()
                end
            else
                vim.notify("Failed to load UI module for Amazon Q", vim.log.levels.ERROR)
            end
        end
    end, desc = "Toggle Amazon Q" },
})
-- wk.register({
--   {
--     { "K", group = "Hover Doc" },
--     { "KK", desc = "GoTo Hover Doc" },
--     { "gx", desc = "Open Link" },
--   }
-- })

-- Resize windows using <Shift> arrow keys
-- map("n", "<C-=>", "<C-w>+", { desc = "Increase Window Height" })
-- map("n", "<C-->", "<C-w>-", { desc = "Decrease window height" })
-- map("n", "<C-,>", "<C-w><", { desc = "Decrease window width" })
-- map("n", "<C-.>", "<C-w>>", { desc = "Increase window width" })

-- Disable default Lsp Commands for Lazy, replaced by lspsaga
