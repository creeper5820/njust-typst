# AGENTS.md

## Skills

| Skill | 路径 | 用途 |
|-------|------|------|
| pixel-verify | `skills/pixel-verify.md` | Typst 样式像素级闭环校验：对比模板 PDF 与当前输出的 top/left/height/gap |

## 字体配置

- 字体文件放在 `njust-typst/assets/`（SimSun、SimHei、KaiTi、Times New Roman）
- Typst 0.14 的 `typst.toml` 不支持 `font-paths`，通过环境变量 `TYPST_FONT_PATHS` 设置
- `.nvim.lua`（项目根目录）设置：

```lua
vim.env.TYPST_FONT_PATHS = vim.fn.fnamemodify("njust-typst/assets", ":p")
```

- Neovim 需启用 `exrc`：在 `options.lua` 中加 `option.exrc = true`
- `.nvim.lua` 需要被信任：将 SHA256 哈希追加到 `~/.local/state/nvim/trust`

## 伪粗体

使用 `@preview/cuti:0.4.0`：

```typst
#import "@preview/cuti:0.4.0": cn-fakebold, fakebold

#cn-fakebold[中文内容]    // 只加粗中文字符
#fakebold[混合内容]       // 整体伪粗体（含英文）
```

适用于没有 Bold 字重的字体（如楷体 KaiTi、宋体 SimSun）。

## 公共 vs 私有

- **放 `common.typ`**：多页共用（字体、字号映射、页边距、正文宽度、cuti 导入、main-body wrapper）
- **留在页面文件**：只在该页用到的坐标、尺寸、辅助函数

## Typst 语法注意

- 内容块 `[...]` 中调用函数需要 `#`：`#set text(...)`, `#align(center)[...]`
- 代码块 `{...}` 中不需要 `#`：`set text(...)`, `align(center)[...]`
- `show: set` 和 `show heading.where(...)` 在函数内不向外传播，需用 **wrapper 模式**（函数包裹内容）才能生效
- `import "path"` 返回模块，不能直接当函数调用；用 `#import "path": func` 导入具体函数
- `place(top + left, dx, dy)` 的坐标相对于当前容器左上角
