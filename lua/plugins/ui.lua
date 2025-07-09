-- Create the UI module first
local M = {}

-- Function to toggle Amazon Q terminal
function M.toggle_amazonq()
  -- Try to load snacks.nvim
  local ok, snacks = pcall(require, "snacks")
  if not ok then
    vim.notify("snacks.nvim not found, falling back to built-in terminal", vim.log.levels.WARN)
    return M.fallback_terminal()
  end
  
  -- Check if terminal function exists
  if not snacks.terminal or type(snacks.terminal) ~= "function" then
    vim.notify("snacks.terminal function not found, falling back to built-in terminal", vim.log.levels.WARN)
    return M.fallback_terminal()
  end
  
  -- Create or toggle Amazon Q terminal using snacks.terminal
  local terminal = snacks.terminal({
    id = "amazonq", -- Unique identifier for the terminal
    name = "Amazon Q", -- Display name
    cmd = "q chat", -- Command to run
    cwd = vim.fn.getcwd(), -- Current working directory
    
    -- Terminal behavior options
    start_insert = true, -- Start in insert mode
    auto_insert = true, -- Auto-enter insert mode when focusing terminal
    auto_close = false, -- Don't close when process exits
    interactive = true, -- Enable interactive mode (auto_insert + start_insert)
    
    -- Window options
    size = { height = 0.3 }, -- 30% of screen height
    position = "bottom", -- Position at the bottom
    
    -- Callbacks
    on_create = function(term)
      -- Mark this buffer as an Amazon Q terminal for Edgy integration
      vim.b[term.buf].amazonq_terminal = true
      
      -- Set buffer options
      vim.api.nvim_buf_set_option(term.buf, "filetype", "amazonq")
      
      -- Set buffer-local mappings
      vim.api.nvim_buf_set_keymap(
        term.buf,
        "n",
        "q",
        "<cmd>lua require('ui').toggle_amazonq()<CR>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        term.buf,
        "t",
        "<C-\\><C-n>",
        "<C-\\><C-n>",
        { noremap = true, silent = true }
      )
    end,
  })
  
  -- Toggle the terminal
  if terminal and type(terminal.toggle) == "function" then
    terminal:toggle()
  else
    vim.notify("Failed to create or toggle terminal, falling back to built-in terminal", vim.log.levels.WARN)
    M.fallback_terminal()
  end
end

-- Fallback terminal implementation
function M.fallback_terminal()
  local term_bufnr = nil
  
  -- Check if Amazon Q terminal buffer already exists
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.b[buf] and vim.b[buf].amazonq_terminal then
      term_bufnr = buf
      break
    end
  end
  
  if term_bufnr and vim.api.nvim_buf_is_valid(term_bufnr) then
    -- Terminal exists, find its window
    local term_win = nil
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == term_bufnr then
        term_win = win
        break
      end
    end
    
    if term_win then
      -- Window exists, close it
      vim.api.nvim_win_close(term_win, true)
    else
      -- Buffer exists but no window, create a new window
      local edgy_loaded = pcall(require, "edgy")
      
      if edgy_loaded then
        -- Let Edgy handle the window creation
        vim.cmd("botright split")
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, term_bufnr)
        vim.api.nvim_win_set_height(win, math.floor(vim.o.lines * 0.3))
      else
        -- Fallback to standard split
        vim.cmd("botright split")
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, term_bufnr)
        vim.api.nvim_win_set_height(win, math.floor(vim.o.lines * 0.3))
      end
    end
  else
    -- Create a new terminal buffer
    vim.cmd("botright split")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_height(win, math.floor(vim.o.lines * 0.3))
    
    -- Open terminal with Amazon Q
    vim.cmd("terminal q chat")
    
    -- Get the buffer of the terminal
    term_bufnr = vim.api.nvim_get_current_buf()
    
    -- Mark this buffer as an Amazon Q terminal
    vim.b[term_bufnr].amazonq_terminal = true
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(term_bufnr, "filetype", "amazonq")
    vim.api.nvim_buf_set_option(term_bufnr, "buflisted", false)
    
    -- Set buffer-local mappings
    vim.api.nvim_buf_set_keymap(
      term_bufnr,
      "n",
      "q",
      "<cmd>lua require('ui').toggle_amazonq()<CR>",
      { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
      term_bufnr,
      "t",
      "<C-\\><C-n>",
      "<C-\\><C-n>",
      { noremap = true, silent = true }
    )
    
    -- Auto-enter terminal mode
    vim.cmd("startinsert")
  end
end

-- Make the module globally available
_G.ui = M

-- Then return the plugin configuration
return {
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      -- Add Amazon Q to the Edgy windows
      opts = opts or {}
      opts.bottom = opts.bottom or {}
      
      table.insert(opts.bottom, {
        ft = "amazonq",
        title = "Amazon Q",
        size = { height = 0.3 },
        filter = function(buf, win)
          return vim.b[buf] and vim.b[buf].amazonq_terminal == true
        end,
      })
      
      return opts
    end,
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      -- We don't need to configure snacks.nvim here
      -- since we're creating the terminal dynamically in the toggle_amazonq function
      return opts
    end,
  },
}
