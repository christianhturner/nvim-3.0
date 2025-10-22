local user = os.getenv("USER")
local obsidian_directory = "/Users/" .. user .. "/Documents/Obsidian"
local OBSIDIAN_VAULT = vim.fn.resolve(obsidian_directory)
return {

    -- {
    --     "MeanderingProgrammer/render-markdown.nvim",
    --     opts = {
    --         completions = {
    --             lsp = {
    --                 enabled = true,
    --             },
    --         },
    --     },
    -- },
    -- {
    --     "saghen/blink.cmp",
    --     opts = {
    --         sources = {
    --             per_filetype = {
    --                 markdown = { inherit_defaults = true },
    --             },
    --         },
    --     },
    -- },

    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        events = { "BufReadPost" .. OBSIDIAN_VAULT .. "/**.md" },
        ---@module 'obsidian'
        ---@type obsidian.config
        opts = {
            ui = { enable = true },
            frontmatter = { enabled = true },
            workspaces = {
                {
                    name = "My Vault",
                    path = OBSIDIAN_VAULT,
                },
            },
            completion = {
                nvim_cmp = true,
                -- min_chars = 2,
            },
        },
        config = function(_, opts)
            require("obsidian").setup(opts)

            local cmp = require("cmp")
            cmp.register_source("obsidian", require("cmp_obsidian").new())
            cmp.register_source("obsidian_new", require("cmp_obsidian_new").new())
            cmp.register_source("obsidian_tags", require("cmp_obsidian_tags").new())
        end,
    },

    {
        "saghen/blink.cmp",
        dependencies = { "saghen/blink.compat" },
        opts = {
            sources = {
                default = { "obsidian", "obsidian_new", "obsidian_tags" },
                providers = {
                    obsidian = {
                        name = "obsidian",
                        module = "blink.compat.source",
                    },
                    obsidian_new = {
                        name = "obsidian_new",
                        module = "blink.compat.source",
                    },
                    obsidian_tags = {
                        name = "obsidian_tags",
                        module = "blink.compat.source",
                    },
                },
            },
        },
    },
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
    -- {
    --     "m4xshen/hardtime.nvim",
    --     dependencies = { "MunifTanjim/nui.nvim" },
    --     opts = {},
    -- },
}
