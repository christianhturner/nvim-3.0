-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Autocmd for setting UI layout based on widescreen vs portrait
-- Candidate events VimEnter and VimResized
local utils = require("utils")

vim.cmd([[
    augroup AutoUI
        au!
        au VimEnter, VimResized * lua LoadUIConfig()
    augroup END
]])

function LoadUIConfig()
    local width, height = utils.get_term_size()

    if width > height then
        require("config.altUI.wide").setup()
    else
        require("config.altUi.tall").setup()
    end
end
