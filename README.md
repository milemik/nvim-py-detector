# Locate python virtual environment



```lua
-- ~/.config/nvim/init.lua

-- Load the venv-selector plugin
local venv_selector = require("venv-selector")

-- Setup the plugin
venv_selector.setup()-- ~/.config/nvim/init.lua
```

## Lazy

```lua
-- ~/.config/nvim/lua/plugins/init.lua

return {
  -- Your existing plugins
  {
    "/milemik/nnvim-py-detector",
    config = function()
      require("venv_selector").setup()
    end,
  },
  -- Other plugins
}
