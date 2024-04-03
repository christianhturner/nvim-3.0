vim.g.dbee_state = 0

return {
    "kndndrj/nvim-dbee",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    build = function()
        require("dbee").install("go")
    end,
    config = function()
        require("dbee").setup()
    end,
    keys = {
        {
            "<C-d>",
            function()
                if vim.g.dbee_state == 0 then
                    require("dbee").open()
                    vim.g.dbee_state = 1
                else
                    require("dbee").toggle()
                end
            end,
        },
    },
}
