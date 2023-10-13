local M = {}

local config = {
  pipe_file_path = "/tmp/previewer_R/pipe",
  previewer_path = "visidata",
  preview_command_pattern = "{previewer} {data}",
}

function M.setup(user_options)
  config = vim.tbl_deep_extend("force", config, user_options)
end

-- 通过preview_command_pattern，得到预览命令
local preview_command = string.gsub(config.preview_command_pattern, "{previewer}", config.previewer_path)
preview_command = string.gsub(preview_command, "{data}", config.pipe_file_path)

-- 检查config.pipe_file_path是否存在，不存在则创建
local check_pipe_file = function(pipe_file_path)
  local pipe_file_dir = string.match(pipe_file_path, "(.*)/")
  vim.fn.system("mkdir -p " .. pipe_file_dir)
  if not vim.fn.filereadable(pipe_file_path) then
    vim.fn.system("mkfifo " .. pipe_file_path)
  end
end

local R_send_to_pipe = function()
  require("iron.core").send(nil,
    string.format(
      "write.table(%s, quote = F, sep = \"\\t\", row.names = F, file = '%s')",
      vim.fn.expand("<cword>"),
      config.pipe_file_path
    )
  )
end

function M.preview_newbuffer()
  check_pipe_file(config.pipe_file_path)
  R_send_to_pipe()
  -- 新创建一个terminal的tab，执行预览命令
  vim.cmd("terminal " .. preview_command)
end

function M.preview_tab()
  check_pipe_file(config.pipe_file_path)
  R_send_to_pipe()
  -- 新创建一个terminal的tab，执行预览命令
  vim.cmd("tabnew | terminal " .. preview_command)
end

return M
