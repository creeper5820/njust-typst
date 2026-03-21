# 南京理工大学课程作业 Typst 模板

南京理工大学课程大作业 Typst 模板，包含封面、摘要、目录、正文与参考文献样式。

## 仓库结构

- `typst.toml`：Typst 包清单元数据
- `template/lib.typ`：模板入口与样式定义
- `template/assets/`：字体与封面资源
- `example/main.typ`：使用包式导入的示例文档

## 使用 --package-path 的示例

示例文档使用包导入，而不是相对路径导入：

```typ
#import "@local/njust-homework:0.1.0": project
```

先准备本地包目录，再通过 `--package-path` 编译：

```bash
mkdir -p ./typst-packages/local/njust-homework/0.1.0
git clone --depth 1 git@github.com:creeper5820/njust-typst.git ./typst-packages/local/njust-homework/0.1.0
typst compile --package-path ./typst-packages example/main.typ example/main.pdf
```

如果系统未安装所需字体，请额外指定包内字体目录：

```bash
typst compile --package-path ./typst-packages --font-path ./typst-packages/local/njust-homework/0.1.0/template/assets example/main.typ example/main.pdf
```
