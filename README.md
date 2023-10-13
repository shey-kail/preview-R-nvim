# preview-R-nvim

`preview-R-nvim` is a neovim plugin, used to preview table-like R variables (such as data.frame, tibble) in iron.nvim. In preview_R, you can specify any csv or tsv file/table browser that you can use comfortably as a previewer to display the R variables you want to show.

## Why does this plugin appear

I want to write R script in neovim, the most important features that I need are: code completion, code execution, and preview of table-like R variables. these features can provided by [Nvim-R](https://github.com/jalvesaq/Nvim-R). It is true that Nvim-r can make nvim as powerful as Rstudio. But there are still two main reasons why I don't want to use it. First, It is written in viml. Second, The communication between nvim and R depends on [nvimcom](https://github.com/jalvesaq/nvimcom). Although it provides powerful functions, it is too complicated.

Fortunately, code completion can be achieved by a series of plugins such as [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig). And code execution(repl) can be implemented by [iron.nvim](https://github.com/Vigemus/iron.nvim). The last piece of the puzzle to complete the perfect experience of writing R scripts in neovim: preview R variables. So I wrote this plug-in.

## What preview-R-nvim does:

preview-R-nvim will create a named pipe file in the path specified by `pipe_file_path` in the configuration. Then, when you want to preview a table-like R variable, preview-R-nvim will let R write the variable to the named pipe file, and then use the previewer specified by `previewer_path` to display the data in the named pipe file.

## Dependencies:

- [iron.nvim](https://github.com/Vigemus/iron.nvim)
- [visidata](https://www.visidata.org/)(optional, as previewer of table-like R variables)

## Installation:

[lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
require("lazy").setup(
  {'shey/preview-R-nvim'}
)
```

## Configuration:

In fact, I think there is no need to configure it. The default configuration is enough for most people.

```lua
require("lazy").setup(
  {
    'shey/preview-R-nvim',
    opts = {
      pipe_file_path = "/tmp/previewer_R/pipe",
      previewer_path = "visidata",
      preview_command_pattern = "{previewer} {data}",
    }
  }
)
```

# How to use:

Just run :PreviewR, neovim will open a new tab to display the previewer you specified to show the R variable under your cursor.

You can set shortcut keys for this process.

for vimL:
```vim
noremap <silent> <leader>pr :PreviewR<CR>
```

for lua:
```lua
vim.api.nvim_set_keymap('n', '<leader>pr', ':PreviewR<CR>', {noremap = true, silent = true})
```
