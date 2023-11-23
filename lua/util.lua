local M = {}

-- 获取选中内容
function M.get_selection()
  -- 如果不是可视模式，报错
  -- if vim.api.nvim_get_mode().mode ~= 'v' then
  --   error('Not in visual mode!')
  -- end

  local bufnr = vim.api.nvim_get_current_buf()                                   -- 获取当前缓冲区号
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(bufnr, '<'))     -- 获取选中起始位置
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(bufnr, '>'))         -- 获取选中结束位置
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_row - 1, end_row, false) -- 获取选中行的内容
  if #lines == 0 then return '' end                                              -- 如果没有选中任何内容，返回空字符串
  lines[1] = string.sub(lines[1], start_col + 1)                                 -- 去掉起始行未选中的部分
  local n = #lines
  if n > 1 then
    lines[n] = string.sub(lines[n], 1, end_col) -- 去掉结束行未选中的部分
  end
  return table.concat(lines, '\n')              -- 拼接所有行，用换行符分隔
end

return M
