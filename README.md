# njust-typst

南京理工大学本科毕业设计（论文）Typst 模板。

基于《南京理工大学本科毕业设计（论文）报告撰写格式》规范，通过像素级对比校验，精确还原模板样式。

## 快速开始

### 环境要求

- [Typst](https://typst.app/) >= 0.14
- 字体：SimSun、SimHei、KaiTi、Times New Roman（位于 `assets/` 目录）

### 编译

```bash
TYPST_FONT_PATHS=./njust-typst/assets typst compile main.typ
```

### Neovim 用户

在项目根目录创建 `.nvim.lua`：

```lua
vim.env.TYPST_FONT_PATHS = vim.fn.fnamemodify("njust-typst/assets", ":p")
```

需启用 `exrc` 并信任该文件。

## 项目结构

```
.
├── main.typ                  # 论文主文件（用户编辑）
├── ref.bib                   # 参考文献数据库
├── njust-typst/
│   ├── lib.typ               # 统一导出
│   ├── common.typ            # 公共样式（字体、字号、页眉页脚、main-body wrapper）
│   ├── pages/
│   │   ├── cover/standard.typ  # 封面
│   │   ├── declare.typ         # 声明
│   │   ├── summary.typ         # 中/英文摘要
│   │   ├── contents.typ        # 目录
│   │   ├── charts.typ          # 图表目录
│   │   ├── reference.typ       # 参考文献
│   │   ├── acknowledge.typ     # 致谢
│   │   └── appendix.typ        # 附录
│   ├── assets/                 # 字体文件
│   └── skills/                 # 开发工具
│       ├── pixel-verify.md     # 像素级校验流程
│       └── njust-template.pdf  # 官方模板 PDF
└── typst.toml
```

## 使用方法

### 1. 设置论文题目

题目只需定义一次，所有页面自动读取：

```typst
#let thesis-title = "你的论文题目"
#njust.thesis-title-state.update(thesis-title)
```

### 2. 封面

```typst
#njust.cover-standard(
  title: thesis-title,
  student-name: "姓名",
  student-number: "学号",
  supervisor: "指导教师",
  department: "学院",
  major: "专业",
  research-direction: "研究方向",
  date: "2026年6月",
)
```

### 3. 声明

```typst
#njust.declare
```

### 4. 摘要

```typst
// 中文摘要
#njust.summary(
  lang: "zh",
  keywords: ("关键词1", "关键词2", "关键词3"),
)[
  摘要正文内容...
]

// 英文摘要
#njust.summary(
  lang: "en",
  keywords: ("keyword1", "keyword2"),
)[
  Abstract content...
]
```

### 5. 目录

```typst
#njust.contents[
  #outline(title: none, indent: 0mm)
]
```

### 6. 图表目录

```typst
#njust.charts()
```

### 7. 正文

正文使用 `main-body` wrapper，样式自动应用：

```typst
#njust.main-body[
  = 一级标题

  == 二级标题

  === 三级标题

  正文内容...
]
```

标题样式自动处理：
- 一级标题：小三号宋体加粗
- 二级标题：四号宋体加粗
- 三级标题：小四号宋体加粗
- 正文：小四号宋体，行距 30px，首行缩进 2em

### 8. 致谢

```typst
#njust.acknowledge[
  致谢内容...
]
```

### 9. 参考文献

```typst
#njust.reference[
  #bibliography("ref.bib", style: "ieee", title: none)
]
```

### 10. 附录

```typst
#njust.appendix[
  == 附录标题

  附录内容...
]
```

## 格式规范

| 元素 | 字号 | 说明 |
|------|------|------|
| 封面标题 | 小二号 | 宋体加粗 |
| 摘要/致谢/附录标题 | 三号 | 宋体加粗，居中 |
| 一级标题 | 小三号 | 宋体加粗，段前段后 30pt |
| 二级标题 | 四号 | 宋体加粗，段前 20pt 段后 24pt |
| 三级标题 | 小四号 | 宋体加粗，段前段后 12pt |
| 正文 | 小四号 | 宋体 + Times New Roman，行距 30px |
| 页眉 | 小五号 | 宋体 |
| 页码 | 小五号 | 宋体，居于外侧 |

页面边距：上 30mm，下 24mm，左 25mm，右 25mm。

## 依赖

- [`@preview/cuti:0.4.0`](https://typst.app/universe/package/cuti/) — 伪粗体（`cn-fakebold`、`fakebold`）
