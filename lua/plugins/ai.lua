return {
    -- {
    --     "saghen/blink.cmp",
    --     dependencies = {
    --         {
    --             "saghen/blink.compat",
    --             optional = true, -- make optional so it's only enabled if any extras need it
    --             opts = {},
    --             version = not vim.g.lazyvim_blink_main and "*",
    --         },
    --     },
    --     opts = {
    --     },
    -- },
    {
        "saghen/blink.cmp",
        version = not vim.g.lazyvim_blink_main and "*",
        build = vim.g.lazyvim_blink_main and "cargo build --release",
        opts_extend = {
            "sources.completion.enabled_providers",
            "sources.compat",
            "sources.default",
        },
        dependencies = {
            "rafamadriz/friendly-snippets",
            "Kaiser-Yang/blink-cmp-avante",
            -- add blink.compat to dependencies
            {
                "saghen/blink.compat",
                optional = true, -- make optional so it's only enabled if any extras need it
                opts = {},
                version = not vim.g.lazyvim_blink_main and "*",
            },
        },
        event = "InsertEnter",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            snippets = {
                expand = function(snippet, _)
                    return LazyVim.cmp.expand(snippet)
                end,
            },
            appearance = {
                -- sets the fallback highlight groups to nvim-cmp's highlight groups
                -- useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release, assuming themes add support
                use_nvim_cmp_as_default = false,
                -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },
            completion = {
                accept = {
                    -- experimental auto-brackets support
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                ghost_text = {
                    enabled = vim.g.ai_cmp,
                },
            },

            -- experimental signature help support
            -- signature = { enabled = true },

            sources = {

                --         sources = {
                --             default = { "avante" },
                --             compat = {
                --                 "avante_commands",
                --                 "avante_mentions",
                --                 "avante_files",
                --             },
                --         },
                -- adding any nvim-cmp sources here will enable them
                -- with blink.compat
                -- compat = {
                --     "avante_commands",
                --     "avante_mentions",
                --     "avante_files",
                -- },
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    avante = {
                        module = "blink-cmp-avante",
                        name = "Avante",
                        opts = {},
                    },
                },
            },

            cmdline = {
                enabled = false,
            },

            keymap = {
                preset = "enter",
                ["<C-y>"] = { "select_and_accept" },
            },
        },
        ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
        config = function(_, opts)
            -- setup compat sources
            local enabled = opts.sources.default
            for _, source in ipairs(opts.sources.compat or {}) do
                opts.sources.providers[source] = vim.tbl_deep_extend(
                    "force",
                    { name = source, module = "blink.compat.source" },
                    opts.sources.providers[source] or {}
                )
                if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
                    table.insert(enabled, source)
                end
            end

            -- add ai_accept to <Tab> key
            if not opts.keymap["<Tab>"] then
                if opts.keymap.preset == "super-tab" then -- super-tab
                    opts.keymap["<Tab>"] = {
                        require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
                        LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
                        "fallback",
                    }
                else -- other presets
                    opts.keymap["<Tab>"] = {
                        LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
                        "fallback",
                    }
                end
            end

            -- Unset custom prop to pass blink.cmp validation
            opts.sources.compat = nil

            -- check if we need to override symbol kinds
            for _, provider in pairs(opts.sources.providers or {}) do
                ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
                if provider.kind then
                    local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                    local kind_idx = #CompletionItemKind + 1

                    CompletionItemKind[kind_idx] = provider.kind
                    ---@diagnostic disable-next-line: no-unknown
                    CompletionItemKind[provider.kind] = kind_idx

                    ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
                    local transform_items = provider.transform_items
                    ---@param ctx blink.cmp.Context
                    ---@param items blink.cmp.CompletionItem[]
                    provider.transform_items = function(ctx, items)
                        items = transform_items and transform_items(ctx, items) or items
                        for _, item in ipairs(items) do
                            item.kind = kind_idx or item.kind
                            item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
                        end
                        return items
                    end

                    -- Unset custom prop to pass blink.cmp validation
                    provider.kind = nil
                end
            end

            require("blink.cmp").setup(opts)
        end,
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
