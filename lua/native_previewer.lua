local api = vim.api
local M = {}

local function print_separate_line(col_length, len, left, mid, separator, right)
  local line = left

  for i = 1, len do
    local mid_line = ''
    for _ = 1, col_length[i] + 2 do
      mid_line = mid_line .. mid
    end

    line = line .. mid_line
    if i ~= len then
      line = line .. separator
    else
      line = line .. right
    end
  end

  return line
end

local function split_string(str, reg, max_item)
  local store = {}
  local count = 0
  for item in string.gmatch(str, reg) do
    table.insert(store, item)

    count = count + 1
    if count == max_item then
      break
    end
  end

  return store
end

local function get_readable_table(all_text, number_line, max_row)
  if number_line == 0 then
    return {}
  end

  local all_line
  local tsv_view = {}

  if number_line == 1 then
    if string.find(all_text[1], '\r') then
      all_line = split_string(all_text[1], '[^"\r"]+', max_row)
    else
      print('Not found line break')
      return
    end
  else
    all_line = all_text
  end

  local _, number_columns = string.gsub(all_line[1], '\t', '')
  number_columns = number_columns + 1

  local max_col_length = {}
  for _ = 1, number_columns do
    table.insert(max_col_length, 0)
  end

  for _, row in ipairs(all_line) do
    local cells = {}
    local i = 1
    for cell in string.gmatch(row, '[^"\t"]+') do
      cell = cell or ''
      if #cell > max_col_length[i] then
        max_col_length[i] = #cell
      end
      i = i + 1

      table.insert(cells, cell)
    end

    table.insert(tsv_view, cells)
  end

  local result = {}
  table.insert(result, print_separate_line(max_col_length, number_columns, '┌', '─', '┬', '┐'))

  for _, row in ipairs(tsv_view) do
    if #result > 1 then
      table.insert(result, print_separate_line(max_col_length, number_columns, '├', '─', '┼', '┤'))
    end

    local line = '│'
    for i = 1, #row do
      line = string.format('%s %-' .. max_col_length[i] .. 's │', line, row[i])
    end

    table.insert(result, line)
  end

  table.insert(result, print_separate_line(max_col_length, number_columns, '└', '─', '┴', '┘'))
  return result
end

function M.preview_tsv_newbuffer(pipe_file_path, buff_name, max_row)
  local get_text = {}
  for line in io.lines(pipe_file_path) do
    table.insert(get_text, line)
  end

  local number_line = #get_text
  local result = get_readable_table(get_text, number_line, max_row) or {}
  local new_buf = api.nvim_create_buf(true, true)
  api.nvim_buf_set_name(new_buf, 'Preview ' .. buff_name)
  api.nvim_set_current_buf(new_buf)
  api.nvim_buf_set_lines(new_buf, 0, number_line, false, result)
end

function M.preview_tsv_tab(pipe_file_path, buff_name, max_row)
  local get_text = {}
  for line in io.lines(pipe_file_path) do
    table.insert(get_text, line)
  end

  local number_line = #get_text
  local result = get_readable_table(get_text, number_line, max_row) or {}
  local new_buf = api.nvim_create_buf(true, true)
  api.nvim_buf_set_name(new_buf, 'Preview ' .. buff_name)
  api.nvim_set_current_buf(new_buf)
  api.nvim_buf_set_lines(new_buf, 0, number_line, false, result)
end

return M
