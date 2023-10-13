local M = {}

M.check = function()
  local previewer_path = require("preview-R-nvim").config.previewer_path
  vim.health.start("preview-R-nvim: Checking dependencies")
  vim.health.report_info("dependencies: \n1. iron.nvim\n2. " .. previewer_path .. "\n")

  -- 检查iron.nvim这个插件是否被安装，如果没安装，发出警告
  if pcall(require, "iron.core") then
    vim.health.ok("iron.nvim: installed")
  else
    vim.health.error("iron.nvim: should be installed")
  end

  -- 检查previewer是否安装并且可执行
  if vim.fn.executable(previewer_path) then
    vim.health.ok(previewer_path .. ": installed")
  else
    vim.health.error(previewer_path .. ": should be installed")
  end
end

return M
