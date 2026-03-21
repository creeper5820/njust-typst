#let project(
  title: "某某水课的课程报告",
  college: "自动化学院 交通工程系",
  major: "轨道交通信号与控制",
  course-name: "课程名称",
  assignment-name: "作业名称",
  id: ("922110800001", "922110800002", "922110800003"),
  name: ("陈某某", "郭某", "罗某"),
  date: "2025年12月",
  summary: "这是一段摘要",
  key-words: ("第一", "第二"),
  body,
) = {
  //
  // Config
  //

  let simsun = "SimSun"
  let simhei = "SimHei"
  let kaiti = "KaiTi"
  let english = "Times New Roman"
  let code-font = "Courier New"

  let FontSize = (
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
    六号: 7.5pt,
    小六: 6.5pt,
    七号: 5.5pt,
    八号: 5pt,
  )

  set page(
    paper: "a4",
    footer: context [
      #set align(center)
      #counter(page).display(
        "1",
      )
    ],
  )

  set heading(numbering: "1.1")

  // 代码块
  show raw: set text(font: ("Courier New", "SimSun"), size: 9pt)

  show raw.where(block: true): it => {
    set par(leading: 0.5em)
    block(
      width: 100%,
      fill: luma(252),
      stroke: 0.5pt + gray,
      inset: 8pt,
      radius: 2pt,
      it,
    )
  }

  show raw.where(block: false): it => {
    text(font: "Courier New", fill: black.lighten(20%), it)
  }

  // 标题
  show heading: it => {
    let size = if it.level == 1 { FontSize.小三 } else if it.level == 2 { FontSize.四号 } else { FontSize.小四 }

    block(above: 1.5em, below: 0.5em)[
      #set text(font: simhei, size: size, weight: "bold")

      #context {
        if it.numbering != none {
          counter(heading).display(it.numbering)
          h(0.5em)
        }
      }
      #it.body
    ]
  }

  // 段落
  set text(
    font: simsun,
    size: FontSize.小四,
    lang: "zh",
  )

  set par(
    first-line-indent: 2em,
    spacing: 1.2em,
    leading: 1.5em,
    justify: true,
  )
  show heading: it => it + h(0pt)


  // 参考文献
  set std.bibliography(style: "gb-7714-2015-numeric")
  set std.bibliography(full: true)

  //
  // Context
  //

  align(center)[

    #image("assets/njust.png", width: 70%)

    #v(2cm)

    // 标题绘制
    #text(size: 2.5em, weight: "bold", font: simhei)[#title]

    #v(2cm)

    #let index-font(it) = text(font: simsun, size: FontSize.三号, weight: "bold", it)
    #let words-font(it) = text(font: kaiti, size: FontSize.三号, it)

    #table(
      align: center + horizon,
      columns: (4cm, auto),
      rows: 1cm,
      stroke: 0.3pt,
      index-font[学院（系）：], words-font[#college],
      index-font[专业  名称：], words-font[#major],
      index-font[课程  名称：], words-font[#course-name],
      index-font[作业  名称：], words-font[#assignment-name],

      ..name
        .zip(id)
        .enumerate()
        .map(((i, pair)) => (
          if i == 0 { index-font[姓名  学号：] } else { [] },
          words-font[
            #box(width: 3em)[
              #set text(lang: "zh")
              #set par(justify: true)
              #pair.at(0)
            ]
            #h(1em)
            #pair.at(1)
          ],
        ))
        .flatten(),

      index-font[成绩：], "",
    )

    #v(1fr)

    #text(date, font: simhei, size: FontSize.三号)
  ]

  pagebreak()

  align(center)[
    #text("摘要", font: simhei, size: FontSize.小三, weight: "bold")
  ]

  v(0.5em)

  block(
    width: 100%,
    inset: (left: 0pt, right: 0pt),
    par(
      first-line-indent: 2em,
      text(summary, font: simsun, size: FontSize.小四),
    ),
  )

  v(1em)

  block(
    width: 100%,
    inset: (left: 0pt, right: 0pt),
    par(
      first-line-indent: 0em,
      text("关键词：", font: simhei, size: FontSize.小四, weight: "bold")
        + text(key-words.join("，"), font: simsun, size: FontSize.小四),
    ),
  )

  pagebreak()

  // 目录部分
  align(center)[
    #text("目录", font: simhei, size: FontSize.小三, weight: "bold")
  ]

  v(0.5em)

  outline(
    title: none,
  )

  pagebreak()

  body
}
