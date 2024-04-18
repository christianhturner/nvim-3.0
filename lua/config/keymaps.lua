-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
-- local del = vim.keymap.del
local wk = require("which-key")

wk.register({
    g = {
        x = { "Open Link" },
    },
    K = {
        name = "Hover Doc",
        K = { "GoTo Hover Doc" },
    },
})

-- Resize windows using <Shift> arrow keys
map("n", "<C-=>", "<C-w>+", { desc = "Increase Window Height" })
map("n", "<C-->", "<C-w>-", { desc = "Decrease window height" })
map("n", "<C-,>", "<C-w><", { desc = "Decrease window width" })
map("n", "<C-.>", "<C-w>>", { desc = "Increase window width" })

-- Disable default Lsp Commands for Lazy, replaced by lspsaga
