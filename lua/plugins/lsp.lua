return {
    {
        "nvim-treesitter/nvim-treesitter",
        ensure_installed = {
            "smithy",
        },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = { eslint = {} },
            setup = {
                eslint = function()
                    require("lazyvim.util").lsp.on_attach(function(client)
                        if client.name == "eslint" then
                            client.server_capabilities.documentFormattingProvider = true
                        elseif client.name == "tsserver" then
                            client.server_capabilities.documentFormattingProvider = false
                        end
                    end)
                end,
            },
        },
    },
}
