#import "../common.typ": content-width, fonts, page-margin, size, thesis-header, thesis-footer, thesis-title-state
#import "@preview/cuti:0.4.0": cn-fakebold

#let appendix(body) = {
  set page(
    paper: "a4",
    margin: page-margin,
    header: context {
      thesis-header(
        odd-left: "毕业设计（论文）报告",
        odd-right: thesis-title-state.get(),
        even-left: "附    录",
        even-right: "毕业设计（论文）报告",
      )
    },
    footer: thesis-footer(numbering: "1"),
    footer-descent: -3mm,
    header-ascent: 9pt,
  )

  // 目录条目
  // 目录条目
  show heading.where(level: 1, numbering: none): none
  heading(level: 1, numbering: none, outlined: true)[附\u{3000}\u{3000}录]

  // 标题 "附    录"：三号宋体加粗，段前段后各 18 磅，居中
  v(10mm)
  align(center)[
    #set text(font: fonts.song, size: size.三号)
    #cn-fakebold[附　　录]
  ]
  v(18pt)

  // 子标题：四号宋体加粗，行距 20 磅（不出现在目录中）
  set heading(outlined: false)
  show heading.where(level: 2): it => {
    set text(font: fonts.song, size: size.四号)
    cn-fakebold(it.body)
    v(20pt - size.四号)
  }

  // 正文：小四号宋体，行距 20 磅，两端对齐
  set text(font: fonts.song, size: size.小四)
  set par(leading: 20pt, justify: true)

  body
}
