// 附件2.8：图表目录

#import "../common.typ": content-width, fonts, page-margin, size, thesis-footer, thesis-header, thesis-title-state
#import "@preview/cuti:0.4.0": cn-fakebold

#let charts(
  figures: none,
  tables: none,
) = {
  set page(
    paper: "a4",
    margin: page-margin,
    header: context thesis-header(
      odd-left: "毕业设计（论文）报告",
      odd-right: thesis-title-state.get(),
      even-left: "图表目录",
      even-right: "毕业设计（论文）报告",
    ),
    footer: thesis-footer(numbering: "1"),
    header-ascent: 9pt,
    footer-descent: -3mm,
  )

  v(10mm)

  // 标题：3号宋体加粗，居中
  align(center)[
    #set text(font: fonts.song, size: size.三号)
    #cn-fakebold[图表目录]
  ]

  v(1em)

  // 正文：小4号宋体，行距20磅
  set text(font: fonts.song, size: size.小四)
  set par(leading: 20pt, justify: true)

  if figures != none {
    figures
  }

  if tables != none {
    if figures != none {
      v(1em)
    }
    tables
  }
}
