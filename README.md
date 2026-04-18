# tree-sitter-gdscript

GDScript (Godot) grammar for [tree-sitter](https://github.com/tree-sitter/tree-sitter)，作为 nvim-treesitter 本地 parser 插件使用。

基于 [prestonknopp/tree-sitter-gdscript](https://github.com/prestonknopp/tree-sitter-gdscript) v6.1.0，增加了：

- Region 可折叠（`#region` / `#endregion`）
- 修正 `not` / `!` 优先级
- 修正内部类的 region 定义干扰 fold 解析
- 丰富的 Godot 内置类型、函数、常量高亮

## 安装

依赖 [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)，由其负责编译 parser。

### lazy.nvim

```lua
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
},
{
  "your-username/tree-sitter-gdscript",
  lazy = false,
}
```

安装后执行 `:TSInstall gdscript`，nvim-treesitter 会自动编译 parser 并部署查询文件。

### 手动安装

```bash
# 将插件放入 runtimepath
cd ~/.local/share/nvim/site/pack/plugins/start/
git clone https://github.com/your-username/tree-sitter-gdscript.git

# 在 Neovim 中执行
:TSInstall gdscript
```

## 使用

安装后自动生效。打开 `.gd` 文件即可获得：

- 语法高亮（含 500+ Godot 内置类、150+ 内置函数、600+ 内置常量）
- 代码折叠（if/for/while/class/match/function/region）
- 缩进
- 代码导航（go to definition）
- 注入（注释拼写检查）

## 语法开发

```bash
# 安装依赖
npm install

# 修改 grammar.js 后，重新生成并测试
npm run genTest

# 仅修改 src/scanner.c 时，直接测试
npm run test

# 格式化
npm run format
```

## 工作原理

插件通过 `User TSUpdate` autocommand 将本地 parser 信息注入 nvim-treesitter 的 parser 注册表，
包括 grammar 源码路径和查询文件目录。编译和安装由 nvim-treesitter 的标准流程处理。

## Godot 同步版本

语法同步至 Godot commit [6ae54fd787](https://github.com/godotengine/godot/commits/6ae54fd787)。

## License

MIT
