#import "../../common.typ": content-width, fonts, page-margin, size

#let split-supervisor(s) = {
  if s.contains(". ") {
    let parts = s.split(". ")
    let name = parts.pop()
    let prefix = parts.join(". ") + ". "
    (prefix, name)
  } else {
    ("", s)
  }
}

// 英文标题折行（无下划线）
#let break-title-en(title, max-width) = context {
  let t = title.trim()
  let lines = ()
  let current = ()

  let measure-line = line => {
    measure(text(font: fonts.times, size: 22pt, weight: "bold")[#line]).width
  }

  if t.contains("\n") {
    for part in t.split("\n") {
      let part = part.trim()
      if part != "" {
        lines = lines + (part,)
      }
    }
  } else {
    for ch in t.clusters() {
      let trial = current + (ch,)
      let trial-line = trial.join()
      if current.len() == 0 or measure-line(trial-line) <= max-width {
        current.push(ch)
      } else {
        let line = current.join().trim()
        if line != "" {
          lines = lines + (line,)
        }
        current = (ch,)
      }
    }

    let line = current.join().trim()
    if line != "" {
      lines = lines + (line,)
    }
  }

  let step = 11.1mm
  let line-h = 10.6mm
  let title-height = if lines.len() == 0 { 0mm } else { step * (lines.len() - 1) + line-h }

  box(width: max-width, height: title-height)[
    #for (i, title-line) in lines.enumerate() [
      #place(top + left, dx: 0mm, dy: step * i)[
        #box(width: max-width)[
          #align(center)[
            #text(font: fonts.times, size: 22pt, weight: "bold")[#title-line]
          ]
        ]
      ]
    ]
  ]
}

#let inner-en(
  title: "",
  student-name: "",
  supervisor-1: "",
  supervisor-2: "",
  date: "",
) = {
  set page(
    paper: "a4",
    margin: page-margin,
    header: none,
    footer: none,
  )

  let title-width = content-width - 20mm

  box(width: 100%, height: 243mm)[
    // 论文题目（22pt TNR bold，自动折行，无下划线）
    #place(top + left, dx: 10mm, dy: 44.2mm)[#break-title-en(title, title-width)]

    // By（18pt TNR italic）
    #place(top + left, dx: 76.7mm, dy: 79mm)[
      #text(font: fonts.times, size: size.小二, style: "italic")[By]
    ]

    // 作者姓名（18pt TNR italic bold）
    #place(top + left, dx: 67.1mm, dy: 89.4mm)[
      #text(font: fonts.times, size: size.小二, style: "italic", weight: "bold")[#student-name]
    ]

    // 指导教师（18pt TNR italic）
    #let (sup1-prefix, sup1-name) = split-supervisor(supervisor-1)
    #place(top + left, dx: 0mm, dy: 123mm)[
      #box(width: content-width + 10mm, align(center)[
        #text(font: fonts.times, size: size.小二, style: "italic")[Supervised by #sup1-prefix]
        #text(font: fonts.times, size: size.小二, style: "italic", weight: "bold")[#sup1-name]
        #if supervisor-2 != "" {
          text(font: fonts.times, size: size.小二, style: "italic")[ & ]
          text(font: fonts.times, size: size.小二, style: "italic", weight: "bold")[#supervisor-2]
        }
      ])
    ]

    // 校名（18pt TNR）
    #place(top + left, dx: 0mm, dy: 211mm)[
      #box(width: content-width + 10mm, align(center)[
        #text(font: fonts.times, size: size.小二)[Nanjing University of Science & Technology]
      ])
    ]

    // 日期（18pt TNR）
    #place(top + left, dx: 0mm, dy: 222mm)[
      #box(width: content-width, align(center)[
        #text(font: fonts.times, size: size.小二)[#date]
      ])
    ]
  ]
}
