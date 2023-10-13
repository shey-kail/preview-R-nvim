if vim.bo.filetype == "r" then
  vim.cmd [[ command! PreviewR :lua require('preview-R-nvim').preview_tab() ]]
end
