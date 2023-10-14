return {
    -- refactoring
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
    -- which key integration
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<leader>r"] = { name = "+refactor" },
            },
        },
    },
}
