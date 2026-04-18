# query 文件冗余问题

## 现象

`:checkhealth vim.treesitter` 报告 `gdscript_n` 的 queries 出现两次。

## 原因

Neovim 通过 runtimepath 发现 queries 文件，查找路径为 `queries/<parser_name>/*.scm`。
当本插件同时满足以下两个条件时，会产生重复：

1. **插件自身在 runtimepath 上**，且包含 `queries/gdscript_n/*.scm` 目录结构
2. **nvim-treesitter 安装时创建 symlink**：`site/queries/gdscript_n` → `<plugin>/queries/gdscript_n`

两者都位于 runtimepath，Neovim 分别从两个路径发现同一组 .scm 文件，导致冗余。

## 分析

关键在于 nvim-treesitter 的安装逻辑（`install.lua:438-440`）：

```lua
if repo and repo.queries and repo.path then -- link queries from local repo
    query_src = fs.joinpath(fs.normalize(repo.path), repo.queries)
    task = do_link_queries
end
```

`do_link_queries` 将 `query_src` 整个目录 symlink 到 `site/queries/<lang>`。

当 `install_info.queries = "queries/gdscript_n"` 时：
- symlink: `site/queries/gdscript_n` → `<plugin>/queries/gdscript_n`
- 插件自身: `<plugin>/queries/gdscript_n/` 也在 runtimepath 上
- 结果: 同一组 .scm 文件被发现两次

## 解决方式

将插件内的 queries 目录扁平化：`queries/<parser_name>/*.scm` → `queries/*.scm`。
同时将 `install_info.queries` 改为 `"queries"`。

扁平化后：
- 插件目录内不再有 `queries/gdscript_n/` 子目录，Neovim 不会从插件自身发现 queries
- nvim-treesitter 创建 symlink: `site/queries/gdscript_n` → `<plugin>/queries`
- Neovim 通过 symlink 找到 `<plugin>/queries/highlights.scm`，路径正确
- queries 只被发现一次

## 注意事项

修改后需重新执行 `:TSInstall gdscript_n`，让 nvim-treesitter 重建 symlink 指向新路径。
