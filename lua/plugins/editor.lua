return {
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = {
            {
                "<leader>ut",
                "<cmd>UndotreeToggle<cr>",
                desc = "Undo Tree Toggle",
            },
            init = function()
                -- Persist undo, refer https://github.com/mbbill/udotree#usage
                local undodir = vim.fn.expand("~/.undo-nvim")
                if vim.fn.has("persistent_undo") == 1 then
                    if vim.fn.isdirectory(undodir) == 0 then
                        os.execute("mkdir -p" .. undodir)
                    end

                    vim.opt.undodir = undodir
                    vim.opt.undofile = true
                end

                vim.g.undotree_WindowLayout = 4
            end,
        },
    },
    {
        "folke/edgy.nvim",
        optional = true,
        opts = function(_, opts)
            opts.right = opts.right or {}
            opts.bottom = opts.bottom or {}
            table.insert(opts.right, {
                title = "Undo Tree",
                ft = "undotree",
                open = "UndoTreeToggle",
            })
            table.insert(opts.bottom, {
                title = "Diff",
                ft = "diff",
                size = { height = 0.3 },
                open = "UndotreeToggle",
            })
        end,
    },
    {
        "folke/which-key.nvim",
        opts = {
            preset = "modern",
        },
    },
}
