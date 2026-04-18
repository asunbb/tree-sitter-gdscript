local M = {}

---Find the parser directory within this plugin's runtime path.
---@return string|nil
local function find_parser_dir()
  local paths = vim.api.nvim_get_runtime_file("parser", true)
  for _, path in ipairs(paths) do
    if path:find("tree%-sitter%-gdscript") then
      return path
    end
  end
  return nil
end

---Setup tree-sitter for GDScript files.
---@param opts table|nil Optional configuration (currently unused).
M.setup = function(opts)
  opts = opts or {}

  -- Register parser directory so Neovim can find parser/gdscript.so
  local parser_dir = find_parser_dir()
  if parser_dir then
    vim.opt.runtimepath:append(parser_dir)
  end

  -- Auto-start treesitter for gdscript buffers
  local group = vim.api.nvim_create_augroup("gdscript_treesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "gdscript",
    callback = function(args)
      local buf = args.buf
      pcall(vim.treesitter.start, buf, "gdscript")
    end,
  })
end

return M
