# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Customizing Plugin Spec

I was a bit confused by how to do this in practice, based on what's described on
[LazyVim - Customizing Plugin Spec](https://www.lazyvim.org/configuration/plugins#%EF%B8%8F-customizing-plugin-specs)
and this made things more clear:

- Modifying default values

```lua
{
  "hrsh7th/nvim-cmp",
  -- The function receives two parameters:
  -- 1. The plugin spec (`_` in this example since we don't use it)
  -- 2. The default `opts` value from LazyVim's config
  opts = function(_, opts)
    -- Modify the default opts by adding to them
    table.insert(opts.sources, { name = "emoji" })
    
    -- You can also change existing values
    opts.completion.keyword_length = 2
    
    -- No need to return anything - the modified `opts` will be used
  end,
}
```

- Replacing with completely new values

```lua
{
  "some-plugin",
  -- For any of ft, event, keys, cmd, opts
  keys = function(_, _default_keys)
    -- Ignore the defaults completely and return your own
    return {
      { "<leader>x", "<cmd>MyCustomCommand<cr>", desc = "Execute Custom Command" },
      { "<leader>y", "<cmd>AnotherCommand<cr>", desc = "Another Command" },
    }
  end,
  
  -- Same principle for other properties
  ft = function(_, _)
    -- Return completely new filetypes
    return { "lua", "rust", "typescript" }
  end,
}
```
