#import "../common.typ": content-width, fonts, page-margin, size, thesis-header, thesis-footer, thesis-title-state
#import "@preview/cuti:0.4.0": cn-fakebold, fakebold

#let contents(body) = {
  set page(
    paper: "a4",
    margin: page-margin,
    header: context thesis-header(
      odd-left: "毕业设计（论文）报告",
      odd-right: thesis-title-state.get(),
      even-left: "目    录",
      even-right: "毕业设计（论文）报告",
    ),
    footer: thesis-footer(numbering: "1"),
    header-ascent: 9pt,
    footer-descent: -3mm,
  )

  set text(font: fonts.song, size: size.小四, lang: "zh")
  set par(leading: 20pt)

  show outline.entry: it => {
    set block(above: 3mm, below: 0pt)
    if it.level == 1 {
      // 一级标题：小四加粗宋体 + Times New Roman（伪粗体，含虚线）
      set text(font: fonts.song, size: size.小四)
      pad(left: 0mm, fakebold(it))
    } else if it.level == 2 {
      // 二级标题：小四宋体+Times New Roman，缩进8mm
      set text(font: (fonts.times, fonts.song), size: size.小四)
      pad(left: 8mm, it)
    } else {
      // 三级标题：小四宋体+Times New Roman，缩进14mm
      set text(font: (fonts.times, fonts.song), size: size.小四)
      pad(left: 14mm, it)
    }
  }

  v(10mm)

  align(center)[
    #set text(size: size.三号)
    #cn-fakebold(text[目　　录])
  ]

  v(6mm)

  body
}
