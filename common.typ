#import "@preview/cuti:0.4.0": cn-fakebold, fakebold

// 全局论文题目 state（main.typ 中设置一次，各页面函数通过 context 读取）
#let thesis-title-state = state("thesis-title", "")

// 范文字体
#let fonts = (
  song: "SimSun",
  hei: "SimHei",
  times: "Times New Roman",
  kai: "KaiTi",
)

// 中文字号 → pt 映射
#let size = (
  初号: 42pt,
  小初: 36pt,
  一号: 26pt,
  小一: 24pt,
  二号: 22pt,
  小二: 18pt,
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
)

// 页面边距（封面通用）
#let page-margin = (
  top: 30mm,
  bottom: 24mm,
  left: 25mm,
  right: 25mm,
)

// 正文区逻辑宽度（160mm = 210mm - 25mm×2）
#let content-width = 160mm

// 正文起始纵向偏移（对齐《标准论文参考》P9 的“绪论”Y）
#let main-body-start-offset = 2mm

// 页眉通用样式（小五号宋体，顶部横线）
// odd-left/odd-right 为奇数页眉左右内容
// even-left/even-right 为偶数页眉左右内容
// 模板规律：
//   奇数页：左="毕业设计（论文）报告"  右=论文题目
//   偶数页：左=当前章节名             右="毕业设计（论文）报告"
#let thesis-header(
  odd-left: "毕业设计（论文）报告",
  odd-right: "",
  even-left: "",
  even-right: "毕业设计（论文）报告",
) = {
  context {
    let pg = counter(page).get().first()
    let is-odd = calc.odd(pg)
    let l = if is-odd { odd-left } else { even-left }
    let r = if is-odd { odd-right } else { even-right }

    set text(font: fonts.song, size: size.小五)
    grid(
      columns: (auto, 1fr),
      align: (left, right),
      l, r,
    )
    v(-8pt)
    line(length: 100%, stroke: 0.5pt)
  }
}

// 页脚通用样式（小五号宋体，页码置于页面外侧）
// 模板：奇数页靠右（left≈782），偶数页靠左（left=107），top=1148（距底约27mm）
#let thesis-footer(numbering: "1") = {
  set text(font: fonts.song, size: size.小五)
  context {
    let pg = counter(page).get().first()
    let is-odd = calc.odd(pg)
    align(if is-odd { right } else { left })[
      #counter(page).display(numbering)
    ]
  }
}

// 正文整体样式封装（wrapper function 模式）
// show: set 规则在函数内不向外传播，但通过 wrapper 包裹内容可以正常生效
// 用法：#main-body[正文内容...]（论文题目通过 thesis-title-state 自动读取）
//
// 格式规范（来源：撰写格式.txt + 模板 P17-P18 XML）：
//   正文：小四宋体+TNR，行距30px，首行缩进2em，两端对齐
//   一级标题：小三号宋体加粗，段前段后30pt（→L2:61px, →body:61px）
//   二级标题：四号宋体加粗，段前20pt段后24pt（→body:51px）
//   三级标题：小四宋体加粗，段前段后17pt（→body:38px）
#let main-body(content) = {
  set page(
    paper: "a4",
    margin: page-margin,
    header: context {
      let title = thesis-title-state.get()
      thesis-header(
        odd-left: "毕业设计（论文）报告",
        odd-right: title,
        even-left: "",
        even-right: "毕业设计（论文）报告",
      )
    },
    footer: thesis-footer(numbering: "1"),
    header-ascent: 14pt,
    footer-descent: -3mm,
  )

  show: set text(font: (fonts.times, fonts.song), size: size.小四)
  show: set par(
    justify: true,
    first-line-indent: (amount: 2em, all: true),
    leading: 12pt,
    spacing: 12pt,
  )

  show heading.where(level: 1): it => {
    set text(font: fonts.song, size: size.小三)
    set block(above: 30pt, below: 30pt)
    fakebold(it)
  }

  show heading.where(level: 2): it => {
    set text(font: fonts.song, size: size.四号)
    set block(above: 20pt, below: 24pt)
    fakebold(it)
  }

  show heading.where(level: 3): it => {
    set text(font: fonts.song, size: size.小四)
    set block(above: 12pt, below: 12pt)
    fakebold(it)
  }

  [
    #v(main-body-start-offset)
    #content
  ]
}
