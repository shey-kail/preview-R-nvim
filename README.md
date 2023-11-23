# preview-R-nvim

`preview-R-nvim` is a neovim plugin, used to preview table-like R variables (such as data.frame, tibble) in iron.nvim. In preview-R-nvim, you can specify any csv or tsv file/table browser that you can use comfortably as a previewer to display the R variables you want to show.

## Why does this plugin appear

I want to write R script in neovim, the most important features that I need are: code completion, code execution, and preview of table-like R variables. these features can provided by [Nvim-R](https://github.com/jalvesaq/Nvim-R). It is true that Nvim-r can make nvim as powerful as Rstudio. But there are still two main reasons why I don't want to use it. First, It is written in viml. Second, The communication between nvim and R depends on [nvimcom](https://github.com/jalvesaq/nvimcom). Although it provides powerful functions, it is too complicated.

Fortunately, code completion can be achieved by a series of plugins such as [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig). And code execution(repl) can be implemented by [iron.nvim](https://github.com/Vigemus/iron.nvim). The last piece of the puzzle to complete the perfect experience of writing R scripts in neovim: preview R variables. So I wrote this plug-in.

## What preview-R-nvim does:

preview-R-nvim will create a named pipe file in the path specified by `pipe_file_path` in the configuration. Then, when you want to preview a table-like R variable, preview-R-nvim will let R write the variable to the named pipe file, and then use the previewer specified by `previewer_path` to display the data in the named pipe file.

## Dependencies:

- [iron.nvim](https://github.com/Vigemus/iron.nvim)
- [visidata](https://www.visidata.org/)(optional, as previewer of table-like R variables)
- csview(optional, as previewer of table-like R variables)

## Installation:

[lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
require("lazy").setup(
  {
    "shey-kail/preview-R-nvim",
    ft = "r",
    dependencies = {
      "hkupty/iron.nvim",
    },
    keys = {
      {
        "<leader>pr",
        mode = { "n", "v" },
        function() require('preview-R-nvim').preview_newbuffer(10) end,
        desc = "preview variable in new buffer"
      },
    },
  }
)
```

## Configuration:

In fact, I think there is no need to configure it. The default configuration is enough for most people.

```lua
require("lazy").setup(
  {
    'shey/preview-R-nvim',
    opts = {
      -- the path of named pipe file
      pipe_file_path = "/tmp/previewer_R/pipe",
      -- the path of previewer
      previewer_path = "csview"
      -- max row to show in previewer
      max_row = 100,
      -- the pattern of preview command
      -- {pipe_file_path} is the path of named pipe file, {previewer} is the path of previewer
      preview_command_pattern = "cat {pipe_file_path} | {previewer}",
      -- the pattern of preview command in preview_manual()
      manual_preview_command_pattern = "cat {pipe_file_path} | {previewer}",
      -- whether use native previewer based on lua(copied from [nvim-preview-csv](https://github.com/Nguyen-Hoang-Nam/nvim-preview-csv))
      native_previewer = true,
    }
  }
)
```

## How to use:

You can preview R variables using the lua function provided by this plugin, as follows

1. preview R variable under cursor in a new buffer in neovim

```lua
require("preview-R-nvim").preview_newbuffer(max_row)
-- params:
-- max_row: the max row of the table-like R variable you want to preview (if not set, the default value is max_row that in configuration)
```


2. preview R variable under cursor in a new tab in neovim

```lua
require("preview-R-nvim").preview_tab(max_row)
-- params:
-- max_row: the max row of the table-like R variable you want to preview (if not set, the default value is max_row that in configuration)
```

3. preview R variable under cursor in a new window in neovim

```lua
require("preview-R-nvim").preview_split(split, positon, win_len, max_row)
-- params:
-- split: the split direction, can be 'v' or 'h'(default: 'v')
-- position: the position of the new window, can be 'left', 'right', 'above', 'below', 'leftabove', 'leftbelow', 'rightabove', 'rightbelow'(default: 'rightbelow')
-- win_len: the length of the new window(default: 40)
-- max_row: the max row of the table-like R variable you want to preview (if not set, the default value is max_row that in configuration)
```


4. This function is usually used for previewing in another window other than neovim

```lua
require("preview-R-nvim").preview_manual(max_row)
-- params:
-- max_row: the max row of the table-like R variable you want to preview (if not set, the default value is max_row that in configuration)
```

You can set shortcut keys for these functions.

for vimL:
```vim
noremap <silent> <leader>pr :lua require("preview-R-nvim").preview_tab()<CR>
```

for lua:
```lua
vim.api.nvim_set_keymap('n', '<leader>pr', require("preview-R-nvim").preview_tab(), {noremap = true, silent = true})
```

## Todo:

~~1. Learn from the preview csv function in [nvim-preview-csv](https://github.com/Nguyen-Hoang-Nam/nvim-preview-csv) as a native previewer~~
2. Finish checkhealth
3. Add some screenshots to readme

## Acknowledgement:

1. [nvim-preview-csv](https://github.com/Nguyen-Hoang-Nam/nvim-preview-csv)
2. [Nvim-R](https://github.com/jalvesaq/Nvim-R)
3. [iron.nvim](https://github.com/Vigemus/iron.nvim)
