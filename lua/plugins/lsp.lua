return {
    {
        "nvim-treesitter/nvim-treesitter",
        ensure_installed = {
            "smithy",
        },
    },
    {
        "neovim/nvim-lspconfig",
        -- Disable LSP Keymaps replaced by lspSaga
        init = function()
            local keys = require("lazyvim.plugins.lsp.keymaps").get()
            keys[#keys + 1] = { "K", false }
        end,
        opts = {
            diagnostics = {
                inlay_hints = {
                    enabled = true,
                },
                codelens = {
                    enabled = true,
                },
            },
        },
    },
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        opts = {},
        config = function(_, opts)
            require("lspsaga").setup(opts)
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            {
                "K",
                "<cmd>Lspsaga hover_doc<cr>",
                desc = "Hover doc",
            },
            {
                "<leader>ck",
                "<cmd>Lspsaga hover_doc ++keep<cr>",
                desc = "Pin Hover Doc",
            },
            -- {
            --     "<leader>cd",
            --     "<cmd>Lspsaga show_buf_diagnostics<cr>",
            --     desc = "Show line diagnostics",
            -- },
            -- {
            --     "]d",
            --     "<cmd>Lspsaga diagnostic_jump_next",
            --     desc = "Next diagnostic",
            -- },
            -- {
            --     "[d",
            --     "<cmd>Lspsaga diagnostic_jump_prev",
            --     desc = "Previous diagnostic",
            -- },
            -- {
            --     "<leader>cD",
            --     "<cmd>Lspsaga peek_definition<cr>",
            --     desc = "Peak definition",
            -- },
            -- {
            --     "<leader>cT",
            --     "<cmd>Lspsaga peek_type_definition<cr>",
            --     desc = "Peak type definition",
            -- },
            {
                "<leader>ci",
                "<cmd>Lspsaga incoming_calls<cr>",
                desc = "Incoming calls",
            },
            {
                "<leader>co",
                "<cmd>Lspsaga outgoing_calls<cr>",
                desc = "Outgoing calls",
            },
            -- {
            --     "<leader>cs",
            --     "<cmd>Lspsaga outline<cr>",
            --     desc = "Symbol outline",
            -- },
            -- {
            --     "<leader>cr",
            --     "<cmd>Lspsaga rename<cr>",
            --     desc = "Rename",
            -- },
            -- {
            --     "<leader>gd",
            --     "<cmd>Lspsaga goto_definition<cr>",
            --     desc = "Go to definition",
            -- },
            -- {
            --     "<leader>gy",
            --     "<cmd>Lspsaga goto_type_definitions<cr>",
            --     desc = "Go to type definition",
            -- },
        },
    },
}
