# Locate python virtual environment


## About

This package will automatically detect python virtual environment.
It will first check for .venv in current directory, then it will try to locate poetry venv location and pipenv location.

In the end it will detect location of virtual environment and add it to pyright.

> INFO
>
> Make sure that you have ```pyright``` installed in your nvim using [Mason](https://github.com/williamboman/mason.nvim) or some other tool. 
>


## LazyVim

```lua
-- ~/.config/nvim/lua/plugins/init.lua

return {
    "milemik/nvim-py-detector"
    config = function()
      require("nvim_py_detector").setup()
    end,
}
```
