return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            { "nvim-neotest/nvim-nio" },
        },
        keys = {
            {
                "<leader>dR",
                function()
                    require("dapui").open({ reset = true })
                end,
                desc = "Reset UI",
            },
        },
    },
}
