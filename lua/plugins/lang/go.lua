return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                gopls = {
                    settings = {},
                    gopls = {},
                    codelenses = { gc_details = true },
                },
            },
        },
    },
}
