# NJUST Typst Homework Template

南京理工大学课程大作业 Typst 模板，包含封面、摘要、目录、正文与参考文献样式。

## Repository Layout

- `typst.toml`: Typst package metadata
- `template/lib.typ`: template entry and style definitions
- `template/assets/`: fonts and cover assets
- `example/main.typ`: full sample document
- `example/quickstart.typ`: minimal sample for quick verification

## Quick Start

```bash
typst compile example/quickstart.typ
```

or compile the full sample:

```bash
typst compile example/main.typ
```
