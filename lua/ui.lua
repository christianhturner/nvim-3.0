-- UI module loader
-- This file ensures that the UI module is properly loaded

-- Load the plugins/ui.lua file to ensure the global UI module is initialized
require("plugins.ui")

-- Return the global UI module
return _G.ui
