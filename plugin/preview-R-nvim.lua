if vim.api.nvim_buf_get_option(0, 'filetype') == 'r' then
  vim.cmd [[ command! PreviewR :lua require('preview-R-nvim').preview_tab() ]]
end
