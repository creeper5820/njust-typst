# Pixel Verify Skill — Typst 样式像素级闭环校验

## 用途

对比 Typst 输出 PDF 与模板 PDF 的像素坐标，确保样式完全一致。

## 核心循环

```
1. 提取模板 PDF 目标页 XML
2. 编译当前 main.typ → PDF → XML
3. Python 脚本对比关键元素的 top/left/height/gap
4. 调整 .typ 文件参数
5. 回到第 2 步
```

## 工具链

| 步骤 | 命令 |
|------|------|
| 模板 PDF → XML | `pdftohtml -f <页码> -l <页码> -xml njust-typst/skills/njust-template.pdf /tmp/tpl.xml` |
| 编译 | `TYPST_FONT_PATHS=./njust-typst/assets typst compile main.typ` |
| 输出 PDF → XML | `pdftohtml -xml main.pdf /tmp/cur.xml` |

## Python 对比模板

```python
import xml.etree.ElementTree as ET

tpl = ET.parse('/tmp/tpl.xml').getroot()
cur = ET.parse('/tmp/cur.xml').getroot()

def find(items, pattern):
    for top, left, h, t in items:
        if pattern in t:
            return (top, left, h)
    return None

# 提取元素列表
def extract(page):
    items = []
    for e in page.findall('.//text'):
        t = ''.join(e.itertext()).strip()
        if t:
            items.append((
                int(e.attrib.get('top','0')),
                int(e.attrib.get('left','0')),
                int(e.attrib.get('height','0')),
                t
            ))
    return items

# 逐项对比
tpl_items = extract(tpl.findall('.//page')[0])
cur_items = extract(cur.findall('.//page')[target_page])

checks = [
    ("L1 标题", "绪论"),
    ("L2 标题", "课题背景"),
    ("正文", "这里是"),
]

for label, pattern in checks:
    t = find(tpl_items, pattern)
    c = find(cur_items, pattern)
    if t and c:
        print(f"{label}: 模板 h={t[2]} 当前 h={c[2]} {'✓' if t[2]==c[2] else '✗'}")
```

## 关键间距对比

```python
# 标题间距
gaps = [
    ("L1→L2", "绪论", "课题背景"),
    ("L2→body", "课题背景", "这里是"),
    ("L3→body", "试剂", "这里是试剂"),
]
for label, p1, p2 in gaps:
    t1, t2 = find(tpl_items, p1), find(tpl_items, p2)
    c1, c2 = find(cur_items, p1), find(cur_items, p2)
    if t1 and t2 and c1 and c2:
        tg = t2[0] - t1[0]
        cg = c2[0] - c1[0]
        print(f"{label}: 模板={tg}px 当前={cg}px 差值={cg-tg:+d}px")
```

## XML 关键信息

```xml
<text top="267" left="143" width="519" height="18" font="5">正文内容</text>
```

- `top/left`: 像素坐标 (893×1263 = A4 210×297mm)
- `height`: 文字框高度 (用于判断字号)
- 坐标换算: `px × 210 / 893 = mm`

## 字号→height 对照表

| 字号 | pt | 实测 h (px) |
|------|-----|-------------|
| 小五 | 09 | 14 |
| 小四 | 12 | 18 |
| 四号 | 14 | 21 |
| 小三 | 15 | 23 |
| 三号 | 16 | 24 |
| 小二 | 18 | 27 |

## 常见问题

- **模板有"附件2.x: xxx"注释**: 会增大 header→title 间距，应以无注释的正文页为基准
- **pdftohtml 不输出横线**: 用 `pdftocairo -svg` 提取 SVG 中的 `<path>` 元素
- **英文 vs 中文 h 不同**: Times New Roman 和宋体在同字号下 h 值有 1-2px 差异，属正常
