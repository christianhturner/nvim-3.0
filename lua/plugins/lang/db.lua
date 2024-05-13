vim.g.dbee_state = 0

local function dbeeUIManager()
    -- if dbee has never been open use open and set state to 1
    if vim.g.dbee_state == 0 then
        require("edgy").toggle()
        require("dbee").open()
        vim.g.dbee_state = 1
    else
        require("edgy").toggle()
        require("dbee").toggle()
    end
end

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
                    require("edgy").toggle()
                    require("dbee").open()
                    vim.g.dbee_state = 1
                else
                    require("edgy").toggle()
                    require("dbee").toggle()
                end
            end,
        },
    },
}
