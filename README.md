# tree-sitter-gdscript

GDScript (Godot) grammar for [tree-sitter](https://github.com/tree-sitter/tree-sitter), packaged as a Neovim plugin.

基于 [prestonknopp/tree-sitter-gdscript](https://github.com/prestonknopp/tree-sitter-gdscript) v6.1.0，增加了：

- Region 可折叠（`#region` / `#endregion`）
- 修正 `not` / `!` 优先级
- 修正内部类的 region 定义干扰 fold 解析
- 丰富的 Godot 内置类型、函数、常量高亮

## 安装

### lazy.nvim

```lua
{
  "your-username/tree-sitter-gdscript",
  build = "make",
  lazy = false,
}
```

### packer.nvim

```lua
use {
  "your-username/tree-sitter-gdscript",
  run = "make",
}
```

### 手动安装

```bash
cd ~/.local/share/nvim/site/pack/plugins/start/
git clone https://github.com/your-username/tree-sitter-gdscript.git
cd tree-sitter-gdscript
make
```

## 构建要求

- C 编译器（cc / gcc / clang）
- （可选）Node.js + tree-sitter CLI：用于语法开发

## 使用

安装后自动生效。打开 `.gd` 文件即可获得：

- 语法高亮（含 500+ Godot 内置类、150+ 内置函数、600+ 内置常量）
- 代码折叠（if/for/while/class/match/function/region）
- 缩进
- 代码导航（go to definition）
- 注入（注释拼写检查）

## 语法开发

```bash
# 修改 grammar.js 后，重新生成并测试
make generate && make test

# 仅修改 src/scanner.c 时，直接测试
make test

# 编译 parser
make

# 格式化
npm run format
```

## Godot 同步版本

语法同步至 Godot commit [6ae54fd787](https://github.com/godotengine/godot/commits/6ae54fd787)。

## License

MIT
