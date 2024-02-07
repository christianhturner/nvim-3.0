return {
    -- cmp
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-nvim-lsp-document-symbol",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
        opts = {
            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                -- { name = "luasnip" },
                { name = "path" },
                { name = "nvim_lsp_signature_help" },
            },
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
        },
        config = function(_, opts)
            local cmp = require("cmp")
            cmp.mapping.preset.insert({
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<c-y>"] = cmp.mapping.complete({ select = false }),
                ["<c-Y>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                }),
            })
            cmp.setup(opts)
            -- `/` cmdline setup.
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "nvim_lsp_document_symbol" },
                }, {
                    { name = "buffer" },
                }),
            })
            -- `:` cmdline setup.
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })
        end,
    },
    -- If I opt to return to using Luasnip check this out https://github.com/L3MON4D3/LuaSnip/issues/525 Suggest using this line within the code
    --luasnip.setup({
    -- region_check_events = "CursorHold,InsertLeave",
    --    those are for removing deleted snippets, also a common problem
    --delete_check_events = "TextChanged,InsertEnter",
    --})
    -- Refactoring
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("refactoring").setup({
                prompt_func_return_type = {
                    go = true,
                    java = true,

                    cpp = true,
                    c = true,
                    h = true,
                    hpp = true,
                    cxx = true,
                },
                prompt_func_param_type = {
                    go = true,
                    java = true,

                    cpp = true,
                    c = true,
                    h = true,
                    hpp = true,
                    cxx = true,
                },
                printf_statements = {},
                print_var_statements = {},
                show_success_message = true,
            })
        end,
        keys = {
            { "<leader>re", ":Refactor extract ", "x", desc = "Extract" },
            {
                "<leader>rf",
                ":Refactor extract_to_file ",
                "x",
                desc = "Extract to file",
            },
            {
                "<leader>rv",
                ":Refactor extract_var",
                "x",
                desc = "Extract variable",
            },
            {
                "<leader>ri",
                ":Refactor inline_var",
                { "x", "n" },
                desc = "Extract inline-variable",
            },
            {
                "<leader>rI",
                ":Refactor inline_func",
                desc = "Extract inline-function",
            },
            { "<leader>rb", ":Refactor extract_block", desc = "Extract block" },
            {
                "<leader>rbf",
                ":Refactor extract_block_to_file",
                desc = "Extract block to file",
            },
        },
    },
}
