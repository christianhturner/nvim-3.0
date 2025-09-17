-- Create the UI module first
local M = {}

-- Variable to track if terminal is hidden
M.terminal_hidden = false
M.terminal_buf = nil

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
        size = { width = 0.2 }, -- 20% of screen width
        position = "right", -- Position at the right

        -- Callbacks
        on_create = function(term)
            -- Store the terminal buffer
            M.terminal_buf = term.buf

            -- Mark this buffer as an Amazon Q terminal for Edgy integration
            vim.b[term.buf].amazonq_terminal = true

            -- Set buffer options
            vim.api.nvim_buf_set_option(term.buf, "filetype", "amazonq")

            -- Set buffer-local mappings
            -- 'q' to hide the terminal window (not close the buffer)
            vim.api.nvim_buf_set_keymap(
                term.buf,
                "n",
                "q",
                "<cmd>lua require('ui').hide_amazonq()<CR>",
                { noremap = true, silent = true, desc = "Hide Amazon Q terminal" }
            )

            -- <Esc> to exit terminal mode but stay in the window
            vim.api.nvim_buf_set_keymap(
                term.buf,
                "t",
                "<Esc>",
                "<C-\\><C-n>",
                { noremap = true, silent = true, desc = "Exit terminal mode" }
            )

            -- <C-v> to enter visual mode directly from terminal mode
            vim.api.nvim_buf_set_keymap(
                term.buf,
                "t",
                "<C-v>",
                "<C-\\><C-n>v",
                { noremap = true, silent = true, desc = "Enter visual mode" }
            )

            -- <C-[> as an alternative to <Esc> for exiting terminal mode
            vim.api.nvim_buf_set_keymap(
                term.buf,
                "t",
                "<C-[>",
                "<C-\\><C-n>",
                { noremap = true, silent = true, desc = "Exit terminal mode" }
            )

            -- <C-o> to temporarily exit terminal mode, execute one command, then return
            vim.api.nvim_buf_set_keymap(
                term.buf,
                "t",
                "<C-o>",
                "<C-\\><C-n>:lua vim.defer_fn(function() vim.cmd('startinsert') end, 100)<CR>",
                { noremap = true, silent = true, desc = "Execute one normal mode command" }
            )

            -- Add an autocmd to make it easier to get back to insert mode
            vim.cmd([[
        augroup AmazonQTerminal
          autocmd!
          autocmd BufEnter <buffer> if &buftype == 'terminal' | startinsert | endif
        augroup END
      ]])
        end,
    })

    -- Toggle the terminal
    if terminal and type(terminal.toggle) == "function" then
        terminal:toggle()
        M.terminal_hidden = false
    else
        vim.notify("Failed to create or toggle terminal, falling back to built-in terminal", vim.log.levels.WARN)
        M.fallback_terminal()
    end
end

-- Function to hide the Amazon Q terminal window without closing the buffer
function M.hide_amazonq()
    -- Find the window containing the Amazon Q terminal
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.b[buf] and vim.b[buf].amazonq_terminal then
            -- Hide the window by closing it, but keep the buffer
            vim.api.nvim_win_close(win, true)
            M.terminal_hidden = true
            return
        end
    end
end

-- Function to show the Amazon Q terminal if it's hidden
function M.show_amazonq()
    if not M.terminal_buf or not vim.api.nvim_buf_is_valid(M.terminal_buf) then
        -- Terminal buffer doesn't exist or is invalid, create a new one
        M.toggle_amazonq()
        return
    end

    -- Check if the terminal is already visible
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == M.terminal_buf then
            -- Terminal is already visible, focus it
            vim.api.nvim_set_current_win(win)
            return
        end
    end

    -- Terminal is hidden, show it
    local edgy_loaded = pcall(require, "edgy")

    if edgy_loaded then
        -- Let Edgy handle the window creation
        vim.cmd("botright vsplit")
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, M.terminal_buf)
        vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.2))
    else
        -- Fallback to standard split
        vim.cmd("botright vsplit")
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, M.terminal_buf)
        vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.2))
    end

    M.terminal_hidden = false

    -- Auto-enter terminal mode
    vim.cmd("startinsert")
end

-- Fallback terminal implementation
function M.fallback_terminal()
    if M.terminal_hidden and M.terminal_buf and vim.api.nvim_buf_is_valid(M.terminal_buf) then
        -- Terminal is hidden, show it
        M.show_amazonq()
        return
    end

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
            -- Window exists, hide it
            vim.api.nvim_win_close(term_win, true)
            M.terminal_hidden = true
            M.terminal_buf = term_bufnr
        else
            -- Buffer exists but no window, create a new window
            M.terminal_buf = term_bufnr
            M.show_amazonq()
        end
    else
        -- Create a new terminal buffer
        vim.cmd("botright vsplit")
        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.2))

        -- Open terminal with Amazon Q
        vim.cmd("terminal q chat")

        -- Get the buffer of the terminal
        term_bufnr = vim.api.nvim_get_current_buf()
        M.terminal_buf = term_bufnr

        -- Mark this buffer as an Amazon Q terminal
        vim.b[term_bufnr].amazonq_terminal = true

        -- Set buffer options
        vim.api.nvim_buf_set_option(term_bufnr, "filetype", "amazonq")
        vim.api.nvim_buf_set_option(term_bufnr, "buflisted", false)

        -- Set buffer-local mappings
        -- 'q' to hide the terminal window (not close the buffer)
        vim.api.nvim_buf_set_keymap(
            term_bufnr,
            "n",
            "q",
            "<cmd>lua require('ui').hide_amazonq()<CR>",
            { noremap = true, silent = true, desc = "Hide Amazon Q terminal" }
        )

        -- <Esc> to exit terminal mode but stay in the window
        vim.api.nvim_buf_set_keymap(
            term_bufnr,
            "t",
            "<Esc>",
            "<C-\\><C-n>",
            { noremap = true, silent = true, desc = "Exit terminal mode" }
        )

        -- <C-v> to enter visual mode directly from terminal mode
        vim.api.nvim_buf_set_keymap(
            term_bufnr,
            "t",
            "<C-v>",
            "<C-\\><C-n>v",
            { noremap = true, silent = true, desc = "Enter visual mode" }
        )

        -- <C-[> as an alternative to <Esc> for exiting terminal mode
        vim.api.nvim_buf_set_keymap(
            term_bufnr,
            "t",
            "<C-[>",
            "<C-\\><C-n>",
            { noremap = true, silent = true, desc = "Exit terminal mode" }
        )

        -- <C-o> to temporarily exit terminal mode, execute one command, then return
        vim.api.nvim_buf_set_keymap(
            term_bufnr,
            "t",
            "<C-o>",
            "<C-\\><C-n>:lua vim.defer_fn(function() vim.cmd('startinsert') end, 100)<CR>",
            { noremap = true, silent = true, desc = "Execute one normal mode command" }
        )

        -- Add an autocmd to make it easier to get back to insert mode
        vim.cmd([[
      augroup AmazonQTerminal
        autocmd!
        autocmd BufEnter <buffer> if &buftype == 'terminal' | startinsert | endif
      augroup END
    ]])

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
            opts.right = opts.right or {}

            table.insert(opts.right, {
                ft = "amazonq",
                title = "Amazon Q",
                size = { width = 0.2 },
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
