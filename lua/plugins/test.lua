return {
    --[[
    -- Jest
    {
        "David-Kunz/jester",
        ft = {
            "typescript",
            "javascript",
            "javascriptreact",
            "typescriptreact",
        },
        keys = {
            {
                "<leader>j",
                "",
                desc = "+Jest",
            },
            {
                "<leader>jn",
                '<cmd>require"jester".run()<cr>',
                desc = "Run Nearest test(s) under the cursor",
            },
            {
                "<leader>jc",
                '<cmd>require"jester".run_file()<cr>',
                desc = "Run current file",
            },
            {
                "<leader>jl",
                '<cmd>require"jester".run_last()<cr>',
                desc = "Run last test(s)",
            },
            {
                "<leader>jN",
                '<cmd>require"jester".debug()<cr>',
                desc = "Debug Nearest test(s) under the cursor",
            },
            {
                "<leader>jC",
                '<cmd>require"jester".debug_file()<cr>',
                desc = "Debug current file",
            },
            {
                "<leader>jL",
                '<cmd>require"jester".debug_last()<cr>',
                desc = "Debug last test(s)",
            },
        },
    },
    ]]
    --
}
