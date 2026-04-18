
# tree-sitter-gdscript

基于 [prestonknopp/tree-sitter-gdscript](https://github.com/prestonknopp/tree-sitter-gdscript) 改进：

- 项目结构重构为 neovim 插件，以本地数据源的方式提供基于 nvim-treesitter 的解析器安装
- 修正内部类的 region 定义干扰 fold 解析
- 新增 Region 可折叠（`#region` / `#endregion`）
- 修正 `not` / `!` 优先级

## 安装

依赖 [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)，由其负责编译解析器。

### lazy.nvim
```lua
{
  "asunbb/tree-sitter-gdscript",
    dependencies = {
      "nvim-treesitter/nvim-treesitter"
    }
}
```

安装后执行 
```bash
:TSUpdate
:TSInstall gdscript_n
```
nvim-treesitter 会自动编译 parser 并部署查询文件。

## 本地开发测试

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

插件通过 `User TSUpdate` autocommand 将本地 parser 信息注入 nvim-treesitter 的 parser 注册表，包括 grammar 源码路径和查询文件目录。

编译和安装由 nvim-treesitter 的标准流程处理。

## 注意事项

初版 scm 文件来源于 nvim-treesitter 仓库，之后会酌情改进。

## License

MIT

## 免责声明

本项目代码主要由 coding agent（AI）生成。

取用由人，使用者自行判断和负责。

因使用本代码导致的任何数据丢失，作者不承担责任。

