local M = {}

local config = {
  pipe_file_path = "/tmp/previewer_R/pipe",
  previewer_path = "csview",
  native_previewer = true,
  max_row = 100,
  preview_command_pattern = "cat {pipe_file_path} | {previewer}",
  manual_preview_command_pattern = "cat {pipe_file_path} | {previewer}",
}

function M.setup(user_options)
  config = vim.tbl_deep_extend("force", config, user_options)
end

-- 通过preview_command_pattern，得到预览命令
local preview_command = string.gsub(config.preview_command_pattern, "{previewer}", config.previewer_path)
preview_command = string.gsub(preview_command, "{pipe_file_path}", config.pipe_file_path)

-- 检查config.pipe_file_path是否存在，不存在则创建
local check_pipe_file = function(pipe_file_path)
  local pipe_file_dir = string.match(pipe_file_path, "(.*)/")
  vim.fn.system("mkdir -p " .. pipe_file_dir)
  -- 如果pipe文件不存在，则创建
  os.execute("test -p " .. pipe_file_path .. " || mkfifo " .. pipe_file_path)
end

-- 令R发送数据到管道文件
local function R_send_to_pipe(max_row)
  -- 根据模式获取变量
  local variable
  if vim.api.nvim_get_mode().mode == 'v' then
    -- 如果是可视模式，则获取选中内容
    variable = require("util").get_selection()
  elseif vim.api.nvim_get_mode().mode == 'n' then
    -- 如果是普通模式，则获取光标所在的变量
    variable = vim.fn.expand("<cword>")
  else
    -- 不然就报错
    error('Not in visual mode or normal mode!')
  end

  max_row = max_row or config.max_row
  require("iron.core").send(nil,
    string.format(
      "write.table(head(%s, %u), quote = F, sep = \"\\t\", row.names = F, file = '%s')",
      variable,
      max_row,
      config.pipe_file_path
    )
  )
end

-- 预览函数（在neovim中的一个新的buffer中预览）
function M.preview_newbuffer(max_row)
  -- 根据模式获取变量
  local variable
  if vim.api.nvim_get_mode().mode == 'v' then
    -- 如果是可视模式，则获取选中内容
    variable = require("util").get_selection()
  elseif vim.api.nvim_get_mode().mode == 'n' then
    -- 如果是普通模式，则获取光标所在的变量
    variable = vim.fn.expand("<cword>")
  else
    -- 不然就报错
    error('Not in visual mode or normal mode!')
  end

  check_pipe_file(config.pipe_file_path)
  R_send_to_pipe(max_row)
  if config.native_previewer == true then
    require("native_previewer").preview_tsv_newbuffer(config.pipe_file_path, variable, max_row)
  else
    vim.cmd("terminal " .. preview_command)
  end
end

-- 预览函数（在neovim中的一个新的tab中预览）
function M.preview_tab(max_row)
  check_pipe_file(config.pipe_file_path)
  R_send_to_pipe(max_row)
  vim.cmd("tabnew | set nonu | set norelativenumber | set signcolumn=no | terminal " .. preview_command)
end

-- 预览函数（在neovim中的一个新的窗口中预览）
function M.preview_split(split, positon, win_len, max_row)
  -- 设置默认值
  split = split or "h"
  positon = positon or "rightbelow"
  win_len = win_len or 40

  check_pipe_file(config.pipe_file_path)
  R_send_to_pipe(max_row)

  if split == "v" then
    local command = string.format(
      "%s %uvsplit | set nonu | set norelativenumber | set signcolumn=no | terminal %s",
      positon, win_len, preview_command
    )
    vim.cmd(command)
  elseif split == "h" then
    local command = string.format(
      "%s %usplit | set nonu | set norelativenumber | set signcolumn=no | terminal %s",
      positon, win_len, preview_command
    )
    vim.cmd(command)
  else
    error("parameter split must be h or v")
  end
end

-- 预览函数（这个函数通常用于在一个其他窗口而非neovim中预览）
function M.preview_manual(max_row)
  max_row = max_row or config.max_row

  check_pipe_file(config.pipe_file_path)
  R_send_to_pipe(max_row)

  local command = string.gsub(config.manual_preview_command_pattern, "{pipe_file_path}", config.pipe_file_path)
  command = string.gsub(command, "{previewer}", config.previewer_path)

  os.execute(command)
end

return M
