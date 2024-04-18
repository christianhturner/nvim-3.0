return {
    {
        "mistricky/codesnap.nvim",
        build = "make",
        opts = {
            has_breadcrumbs = true,
            breadcrumbs_separator = " ==> ",
            watermark = "github.com/chturner94",
        },
        config = function(_, opts)
            local xdg_config = vim.env.XDG_CONFIG_HOME or vim.env.HOME
            local screenshot_dir = "Pictures/codesnap-screenshots"

            local function have()
                if not vim.uv.fs_stat(xdg_config .. "/" .. screenshot_dir) then
                    local new_dir = xdg_config .. "/" .. screenshot_dir
                    local success, err = vim.uv.fs_mkdir(new_dir, 493)
                    if not success then
                        error("Failed to create directory: " .. err)
                    end
                end
            end
            have()

            local codesnap_dir = xdg_config .. "/" .. screenshot_dir

            local options =
                vim.tbl_extend("force", opts, { save_path = codesnap_dir })

            require("codesnap").setup(options)
        end,
    },
}
