#import "config.typ": *
#show link: underline
#show link: set text(fill: rgb("#000"))
#show outline.entry.where(level: 1): set text(fill: rgb("#000"), weight: "bold")
#show outline.entry.where(level: 2): set text(fill: rgb("#111"))
#show outline.entry.where(level: 3): set text(fill: rgb("#222"))
#show outline.entry.where(level: 3): set text(fill: rgb("#333"))

#set text(
    font: "New Computer Modern"
)
#set par(
    justify: true,
    leading: 0.52em
)
#set document(
    title: [Documentation of Djehuty: a data and software repository system.],
    author: "Roel Janssen <rrejanssen@gmail.com>",
    keywords: "",
    date: datetime.today(),
)
#set heading(numbering: "1.1")
#let target = dictionary(std).at("target", default: () => "paged")
#set page(numbering: "1", paper: "a4", margin: (x: 2.0cm, y: 2.0cm))

#context if target() == "html" {
    html.elem("head")[
        #html.elem("style", attrs: (type: "text/css"))[
            html { width: 100%; margin: 0em; padding: 0em; background: repeating-linear-gradient(90deg, \#f3f3f3 0, \#f3f3f3 5%, transparent 0, transparent 50%), repeating-linear-gradient(180deg, \#f3f3f3 0, \#f3f3f3 5%, transparent 0, transparent 50%); background-size: 1em 1em; background-color: \#f9f9f9; }
            body { margin: 12pt auto 0pt auto; max-width: 1074pt; min-width: 720pt; }
            \@media (max-width: 1074pt) {
            .table-of-contents { margin: auto auto 1em auto; max-width: 1074pt; min-width: 720pt; width: 820pt; background: \#fff; color: \#111; padding: 0em; border: solid 1pt \#ccc; border-radius: 1em 1em .5em .5em; }
            .chapter { margin: auto auto 1em auto; }
            section[role=doc-endnotes] { margin-left: auto; }
            }
            \@media (min-width: 1074pt) {
            .chapter { margin-left: 254pt !important; }
            .table-of-contents { position: fixed; height: auto; overflow-y: auto; width: 240pt; min-width: 240pt; max-width: 240pt; display: inline-block; border: solid 1pt \#ccc; padding: 0em; margin: 0em; background: \#fff; color: \#111; border-radius: .5em; }
            nav > ol > li > ol > li > ol > li > span > a,
            nav > ol > li > ol > li > ol > li > div > span { display: none; }
            nav > ol > li > ol > li > span >a,
            nav > ol > li > ol > li > div > span > a { font-size: 0.9em; }
            section[role=doc-endnotes] { margin-left: 254pt; }
	    .table-of-contents > nav > ol > li > ol { display: none; }
            #chapter-toc-css(9)
            }
            .table-of-contents p { padding: 0em 0em 0em 1em; margin-bottom: 0em; }
            .table-of-contents ol { margin: 0em; padding: 1em 0em 1em 0em; line-height: 1.3em; }
            .table-of-contents ol ol { margin: 0em; padding: 0em 1em 0em 1em; }
            .table-of-contents h2 { background: \#ccc; color: \#111; padding: .75em; margin: 0em; }
            nav > ol { margin-top: 0em; }
            nav > ol > li { margin: 0em; }
            nav > ol > li > div > span > a,
            nav > ol > li > span > a { display: inline-block; width: calc(100% - 2em); background: \#f6f6f6; padding: .25em 1em .25em 1em; margin: .25em 0em .25em 0em; font-size: 1.2em; color: \#111; border-top: solid 1pt \#ccc; border-bottom: solid 1pt \#ccc; }
            nav > ol > li > ol > li > span > a,
            nav > ol > li > ol > li > div > span > a { color: \#7c0000; }
            nav > ol > li > ol > li > span > a:hover,
            nav > ol > li > ol > li > div > span > a:hover { color: \#af6666; }
            nav > ol > li > ol > li > ol > li > span > a { color: \#00007c; }
            nav > ol > li > ol > li > ol > li > span > a:hover { color: \#6666af; }
            .center { text-align: center; }
            img { display: block; max-width: 760pt; margin: 1em auto 1em auto; padding: auto; }
            figure { background: \#fcfcfc; border: solid 1pt \#ccc; border-radius: .5em; }
            figcaption { text-align: center;  border-top: solid 1pt \#ccc; border-radius: 0em 0em .5em .5em; background: \#eee; padding: .5em; }
            .chapter { margin: auto auto 1em auto; max-width: 1074pt; min-width: 720pt; width: 820pt; background: \#fff; color: \#111; padding: 0em; border: solid 1pt \#ccc; border-radius: .5em; }
            .chapter p, .chapter pre, .chapter table { padding: 0pt 12pt 0pt 12pt; }
            .chapter h2 { background: \#222; color: \#fff; padding: .75em; margin: 0em; border-radius: .25em .25em 0em 0em; }
            .chapter h3 { font-size: 1.25em; padding: .25em 1em .25em 1em; background: \#eee; }
            .chapter h4 { font-size: 1.10em; padding: .25em 1em .25em 1em; background: \#f6f6f6; }
            .chapter h5 { font-size: 1.0em; padding: .25em 1em .25em 1em; background: \#f6f6f6; }
            .chapter pre { background: \#f8f8f8; margin: 0pt 10pt 0pt 10pt; padding: 10pt; border-radius: 5pt; border: solid 1pt \#ccc; }
            table { width: 100%; margin: 0em 1em 0em 0em; border-collapse: separate; border-spacing: 0em; border-radius: .5em;}
            table tbody tr td { border: solid 1pt \#333; padding: .25em; border-top: none; border-left: 0; }
            table thead tr th { background: \#333; color: \#fff; padding: .5em .25em .5em .25em; }
            table thead tr th:first-child { border: solid 1pt \#333;  border-radius: 0.5em 0.5em 0em 0em; }
            table thead tr th:last-child { border: solid 1pt \#333; border-radius: 0.5em 0.5em 0em 0em; }
            table thead tr th { text-align: left; }
            table thead tr:first-child th:first-child { border-radius: 0.5em 0 0 0; }
            table thead tr:first-child th:last-child { border-radius: 0 0.5em 0 0; }
            table tbody tr:last-child td:last-child { border-radius: 0 0 0.5em 0; }
            table tbody tr:last-child td:first-child { border-radius: 0 0 0 0.5em; }
            table tbody tr:nth-child(even) { background: \#f6f6f6; }
            table tbody tr td:first-child { border-left: solid 1pt \#333; }
            section[role=doc-endnotes] ol { padding-left: .5em; }
        ]
    ]
}

// Title page & Table of Contents
// ----------------------------------------------------------------------------
#context if target() == "paged" {
    page(numbering: none)[
        #align(center + horizon)[
            #image("figures/logo.svg")
            #text(size: 28pt, weight: "bold")[`seshat`]
            #v(1em)
            #text(size: 16pt)[A data and software repository system]
            #v(2em)
            #line(length: 60%)
            #v(2em)
            #text(size: 14pt)[Roel Janssen]
            #v(2em)
            #text(size: 12pt)[#datetime.today().display("[month repr:long] [day], [year]")]
        ]
    ]
    page(numbering: "i")[
        #heading(outlined: false, numbering: none)[Table of Contents]
        #outline(title: none, indent: 1.5em, depth: 3)
    ]
}
#context if target() == "html" {
    html.elem("div", attrs: (class: "table-of-contents"))[
        #html.elem("h2")[#html.elem("code")[seshat]]
        #html.elem("p")[This document is also available as #html.elem("a", attrs: (href: "seshat.pdf"))[PDF].]
        #outline(
            title: none,
            indent: 1.5em,
            depth: 3,
        )
    ]
}

#context if target() == "paged" {
    set page(numbering: "1")
    counter(page).update(1)
}

#include "introduction.typ"
#pagebreak-when-paged()
#include "running-seshat.typ"
#pagebreak-when-paged()
#include "knowledge-graph.typ"
#pagebreak-when-paged()
#include "contributing.typ"
#pagebreak-when-paged()
#include "api.typ"
#pagebreak-when-paged()
#let bib = bibliography("references.bib", style: "apa")
#render_chapter(bib, "Bibliography")
#pagebreak-when-paged()
#include "contact.typ"
#pagebreak-when-paged()
#include "news.typ"

#context if target() == "html" {
  html.elem("script", read("toc-scroll-helper.js"))
}
