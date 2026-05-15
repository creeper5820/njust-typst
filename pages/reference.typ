// 附件2.11：参考文献

#import "../common.typ": content-width, fonts, page-margin, size, thesis-header, thesis-footer, thesis-title-state
#import "@preview/cuti:0.4.0": cn-fakebold
#import "@preview/modern-nju-thesis:0.4.1": bilingual-bibliography

#let reference-bibliography(rendered-bibliography) = {
  bilingual-bibliography(bibliography: rendered-bibliography)
}

#let reference(source, style: "gb-7714-2015-numeric", title: none, full: false) = {
  set page(
    paper: "a4",
    margin: page-margin,
    numbering: "1",
    header: context {
      thesis-header(
        odd-left: "毕业设计（论文）报告",
        odd-right: thesis-title-state.get(),
        even-left: "参考文献",
        even-right: "毕业设计（论文）报告",
      )
    },
    footer: thesis-footer(),
    header-ascent: 9pt,
    footer-descent: -3mm,
  )

  // 目录条目
  show heading.where(level: 1, numbering: none): none
  heading(level: 1, numbering: none, outlined: true)[参考文献]

  // 标题：3号宋体加粗，居中
  v(10mm)
  align(center)[
    #set text(font: fonts.song, size: size.三号)
    #cn-fakebold[参考文献]
  ]

  v(8pt)

  // 正文：小4号宋体，行距20磅（基线到基线），两端对齐
  // 模板XML验证：行间距30px = 20pt（基线到基线），字号18px = 12pt
  // leading = 20pt - 12pt = 8pt
  set text(font: (fonts.times, fonts.song), size: size.小四)
  set par(justify: true, leading: 12pt, spacing: 12pt)

  reference-bibliography(
    bibliography.with(source, style: style, title: title, full: full),
  )
}
