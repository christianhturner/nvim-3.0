local M = {}

local debug = false

function M.get_term_size()
    local uis = vim.api.nvim_list_uis()
    local width = tonumber(uis[1].width) * 0.42
    local height = tonumber(uis[1].height)

    if debug then
        print("Width:", width)
        print("Height:", height)
    end
    return width, height
end

return M
