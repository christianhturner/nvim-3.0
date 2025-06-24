return {
    {
        "saghen/blink.cmp",
        version = not vim.g.lazyvim_blink_main and "*",
        build = vim.g.lazyvim_blink_main and "cargo build --release",
        opts_extend = {
            "sources.compat",
        },
        dependencies = {
            "Kaiser-Yang/blink-cmp-avante",
            -- add blink.compat to dependencies
            {
                "saghen/blink.compat",
                optional = true, -- make optional so it's only enabled if any extras need it
                opts = {},
                version = not vim.g.lazyvim_blink_main and "*",
            },
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            sources = {
                providers = {
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        opts = {},
                    },
                },
            },
        },
    },
    {
        "yetone/avante.nvim",
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make", -- ⚠️ must add this line! ! !
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        ---@module 'avante'
        ---@type avante.Config
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            -- add any opts here
            -- for example
            provider = "bedrock",
            providers = {
                bedrock = {
                    model = "us.anthropic.claude-3-5-sonnet-20241022-v2:0",
                    aws_region = "us-west-2",
                    aws_profile = "avante-profile",
                    disable_tools = true,
                },
                claude = {
                    endpoint = "https://api.anthropic.com",
                    -- "claude-sonnet-4-20250514",
                    model = "claude-sonnet-3.5-20241022",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 20480,
                    },
                },
            },
            selector = {
                --- @type avante.SelectorProvider
                provider = "snacks",
                -- Options override for custom providers
                provider_opts = {},
            },
            file_selector = {
                provider = "snacks",
            },
            input = {
                provider = "snacks",
                provider_opts = {
                    -- Additional snacks.input options
                    title = "Avante Input",
                    icon = " ",
                },
            },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "ibhagwan/fzf-lua", -- for file_selector provider fzf
            "folke/snacks.nvim", -- for input provider snacks
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
}
