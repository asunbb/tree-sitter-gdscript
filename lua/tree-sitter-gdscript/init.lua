--- tree-sitter-gdscript — GDScript 语法插件的 Lua 模块
--- 将 GDScript 解析器（gdscript-n）注册为 nvim-treesitter 本地 parser 源，
--- 与 nvim-treesitter 内置的 gdscript 解析器区分。
--- 安装/更新由 nvim-treesitter 框架的标准流程处理。

local M = {}

--- 获取插件根目录的绝对路径
--- 利用 Lua 的 debug.getinfo 获取当前文件路径，再向上三级目录得到插件根。
--- 路径推算：init.lua → tree-sitter-gdscript/ → lua/ → <插件根目录>
---@return string 插件根目录的绝对路径
function M.get_root()
  local source = debug.getinfo(1, "S").source:sub(2)
  return vim.fn.fnamemodify(source, ":p:h:h:h")
end

--- 插件初始化入口
--- 1. 注册 TSUpdate autocommand，在 nvim-treesitter 安装时注入 gdscript-n parser 信息
--- 2. 将 Neovim 的 gdscript filetype 映射到 gdscript-n parser
---@param opts table|nil 预留配置项（暂未使用）
function M.setup(opts)
  opts = opts or {}

  -- nvim-treesitter 的 install/update 流程会先调用 reload_parsers() 清除模块缓存，
  -- 然后才触发 User TSUpdate 事件。
  -- 因此直接注册 parsers 表无效（会被清除），必须用 autocommand 在 TSUpdate 事件中注入。
  -- require 放在回调内部，确保此时 nvim-treesitter 已加载。
  vim.api.nvim_create_autocmd("User", {
    pattern = "TSUpdate",
    callback = function()
      local ok, ts_parsers = pcall(require, "nvim-treesitter.parsers")
      if not ok then
        return
      end
      ts_parsers["gdscript_n"] = {
        install_info = {
          -- 本地 parser 路径，使用插件根目录（包含 grammar.js、src/ 等文件）
          path = M.get_root(),
          -- generate = false：src/parser.c 已包含在仓库中，无需从 grammar.js 重新生成
          generate = false,
          -- queries：指定查询文件目录（相对于插件根目录），
          -- Neovim 通过 runtimepath 的 queries/<language>/*.scm 发现查询
          queries = "queries",
        },
      }
    end,
  })

  -- 将 filetype "gdscript" 映射到 parser 名 "gdscript_n"
  vim.treesitter.language.register("gdscript_n", { "gdscript" })
end

return M
