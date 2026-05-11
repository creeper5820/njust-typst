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
| 模板 PDF → XML | `pdftohtml -f <页码> -l <页码> -xml <模板.pdf> /tmp/tpl.xml` |
| 编译 | `TYPST_FONT_PATHS=./assets typst compile main.typ` |
| 输出 PDF → XML | `pdftohtml -f <页码> -l <页码> -xml main.pdf /tmp/cur.xml` |

## 必须对比的维度（缺一不可）

每次验证必须对比以下 **5 个维度**：

| 维度 | 说明 | 判定标准 |
|------|------|----------|
| **1. 字号对比** | height 值对比 | 差值 ≤ 2px 为正常（字体渲染差异） |
| **2. 间距对比** | 相邻元素 top 差值对比 | 差值 ≤ 2px 为正常 |
| **3. 位置对比** | 元素 top 值对比 | 用于定位偏移分析 |
| **4. 字体对比** | font family 对比 | 宋体/楷体/黑体/TNR 必须匹配 |
| **5. 内容对比** | 文字内容对比 | 确保文字正确（含空格） |

## Python 通用对比脚本

```python
import xml.etree.ElementTree as ET

# ── 配置（使用前修改）──
TPL_XML = '/tmp/tpl.xml'
CUR_XML = '/tmp/cur.xml'
TPL_PAGE = 0  # 模板页码索引（0-based）
CUR_PAGE = 0  # 当前页码索引（0-based）

# 需要对比的元素列表: (标签, 模板中的文字, 期望字体关键词)
# 字体关键词: SimSun(宋体), KaiTi(楷体), SimHei(黑体), TimesNewRoman
CHECK_ITEMS = [
    ("标题", "学 士 学 位 论 文", "KaiTi"),
    ("学生姓名", "陈瑶", "KaiTi"),
    # ... 根据页面添加
]

# 需要对比的间距列表: (标签, 元素1文字, 元素2文字)
CHECK_GAPS = [
    ("标题→姓名", "学 士 学 位 论 文", "陈瑶"),
    # ... 根据页面添加
]

# ── 提取元素 ──
def extract(page):
    """提取页面所有文字元素: (top, left, height, text, font_id)"""
    items = []
    for e in page.findall('.//text'):
        t = ''.join(e.itertext()).strip()
        if t:
            items.append((
                int(e.attrib.get('top','0')),
                int(e.attrib.get('left','0')),
                int(e.attrib.get('height','0')),
                t,
                e.attrib.get('font','')
            ))
    return items

def find(items, pattern):
    """查找包含指定文字的元素"""
    for item in items:
        if pattern in item[3]:
            return item
    return None

def get_font_name(font_id, page_elem):
    """获取字体名称"""
    for f in page_elem.findall('.//fontspec'):
        if f.attrib.get('id') == font_id:
            return f.attrib.get('family', 'unknown')
    return 'unknown'

# ── 加载数据 ──
tpl = ET.parse(TPL_XML).getroot()
cur = ET.parse(CUR_XML).getroot()

tpl_page = tpl.findall('.//page')[TPL_PAGE]
cur_page = cur.findall('.//page')[CUR_PAGE]

tpl_items = extract(tpl_page)
cur_items = extract(cur_page)

# ── 维度 1: 字号对比 ──
print("=" * 60)
print("维度 1: 字号对比 (height)")
print("=" * 60)

font_ok = 0
font_fail = 0
for label, pattern, _ in CHECK_ITEMS:
    t = find(tpl_items, pattern)
    c = find(cur_items, pattern)
    if t and c:
        status = "✓" if abs(t[2] - c[2]) <= 2 else "✗"
        if status == "✓": font_ok += 1
        else: font_fail += 1
        print(f"  {label:15s}: 模板 h={t[2]:2d} 当前 h={c[2]:2d} {status}")
    else:
        font_fail += 1
        print(f"  {label:15s}: 未找到 ✗")

# ── 维度 2: 间距对比 ──
print("\n" + "=" * 60)
print("维度 2: 间距对比 (top 差值)")
print("=" * 60)

gap_ok = 0
gap_fail = 0
for label, p1, p2 in CHECK_GAPS:
    t1, t2 = find(tpl_items, p1), find(tpl_items, p2)
    c1, c2 = find(cur_items, p1), find(cur_items, p2)
    if t1 and t2 and c1 and c2:
        tg = t2[0] - t1[0]
        cg = c2[0] - c1[0]
        status = "✓" if abs(cg - tg) <= 2 else "✗"
        if status == "✓": gap_ok += 1
        else: gap_fail += 1
        print(f"  {label:20s}: 模板={tg:3d}px 当前={cg:3d}px 差值={cg-tg:+3d}px {status}")

# ── 维度 3: 位置对比 ──
print("\n" + "=" * 60)
print("维度 3: 位置对比 (top 偏移)")
print("=" * 60)

pos_ok = 0
pos_fail = 0
for label, pattern, _ in CHECK_ITEMS:
    t = find(tpl_items, pattern)
    c = find(cur_items, pattern)
    if t and c:
        diff = c[0] - t[0]
        status = "✓" if abs(diff) <= 5 else "⚠"
        if abs(diff) <= 5: pos_ok += 1
        else: pos_fail += 1
        print(f"  {label:15s}: 模板={t[0]:4d} 当前={c[0]:4d} 偏移={diff:+d}px {status}")

# ── 维度 4: 字体对比 ──
print("\n" + "=" * 60)
print("维度 4: 字体对比 (font family)")
print("=" * 60)

ff_ok = 0
ff_fail = 0
for label, pattern, expected in CHECK_ITEMS:
    c = find(cur_items, pattern)
    if c:
        font_name = get_font_name(c[4], cur_page)
        if expected.lower() in font_name.lower():
            ff_ok += 1
            print(f"  {label:15s}: {font_name[:25]:25s} ✓")
        else:
            ff_fail += 1
            print(f"  {label:15s}: {font_name[:25]:25s} ✗ (期望 {expected})")

# ── 维度 5: 内容对比 ──
print("\n" + "=" * 60)
print("维度 5: 内容对比 (文字正确性)")
print("=" * 60)

ct_ok = 0
ct_fail = 0
for label, expected, _ in CHECK_ITEMS:
    c = find(cur_items, expected)
    if c and expected in c[3]:
        ct_ok += 1
        print(f"  {label:15s}: '{c[3][:25]}' ✓")
    else:
        ct_fail += 1
        print(f"  {label:15s}: 未找到或不匹配 ✗")

# ── 汇总 ──
print("\n" + "=" * 60)
print("汇总")
print("=" * 60)
print(f"  字号: {font_ok}/{font_ok+font_fail}  间距: {gap_ok}/{gap_ok+gap_fail}  位置: {pos_ok}/{pos_ok+pos_fail}")
print(f"  字体: {ff_ok}/{ff_ok+ff_fail}  内容: {ct_ok}/{ct_ok+ct_fail}")

total_ok = font_ok + gap_ok + pos_ok + ff_ok + ct_ok
total_all = (font_ok+font_fail) + (gap_ok+gap_fail) + (pos_ok+pos_fail) + (ff_ok+ff_fail) + (ct_ok+ct_fail)
print(f"\n  总计: {total_ok}/{total_all} 通过")
```

## XML 关键信息

```xml
<text top="267" left="143" width="519" height="18" font="5">正文内容</text>
<fontspec id="5" size="12" family="TimesNewRoman" color="#000000"/>
```

- `top/left`: 像素坐标 (893×1263 = A4 210×297mm)
- `height`: 文字框高度 (用于判断字号)
- `font`: 字体 ID (对应 fontspec 中的 id)
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
| 二号 | 22 | 33 |
| 小一 | 24 | 36 |
| 一号 | 26 | 39 |
| 小初 | 36 | 54 |

## 常见问题

- **英文 vs 中文 h 不同**: Times New Roman 和宋体在同字号下 h 值有 1-2px 差异，属正常
- **楷体 vs 宋体 h 不同**: 同字号下楷体 h 可能比宋体大 1px，属正常
- **font ID 不同**: 模板和当前编译的 font ID 可能不同，需通过 fontspec 查找实际字体名称
