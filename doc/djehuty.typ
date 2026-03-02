#import "config.typ": *

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
#context if target() == "paged" {
    set page(
        numbering: "1",
        paper: "a4",
        margin: (x: 2.0cm, y: 2.0cm)
    )
}
#context if target() == "html" {
    html.elem("head")[
        #html.elem("style", attrs: (type: "text/css"))[
            html { width: 100%; margin: 0em; padding: 0em; background: repeating-linear-gradient(90deg, \#f3f3f3 0, \#f3f3f3 5%, transparent 0, transparent 50%), repeating-linear-gradient(180deg, \#f3f3f3 0, \#f3f3f3 5%, transparent 0, transparent 50%); background-size: 1em 1em; background-color: \#f9f9f9; }
            body { margin: 12pt auto 0pt auto; max-width: 1074pt; min-width: 720pt; }
            \@media (max-width: 1074pt) {
            .table-of-contents { margin: auto auto 1em auto; max-width: 1074pt; min-width: 720pt; width: 850pt; background: \#fff; color: \#111; padding: 0em; border: solid 1pt \#ccc; border-radius: 1em 1em .5em .5em; }
            .chapter { margin: auto auto 1em auto; }
            }
            \@media (min-width: 1074pt) {
            .table-of-contents { position: fixed; height: 100vh; overflow-y: auto; width: 210pt; min-width: 210pt; max-width: 210pt; display: inline-block; border: solid 1pt \#ccc; padding: 0em; margin: 0em; background: \#fff; color: \#111; border-radius: 1em; }
            .chapter { margin-left: 224pt !important; }
            nav > ol > li > ol > li > ol > li > a,
            nav > ol > li > ol > li > ol > li > div { display: none; }
            nav > ol > li > ol > li > a,
            nav > ol > li > ol > li > div > a { font-size: 0.9em; }
            }
            .table-of-contents p { padding: 0em 0em 0em 1em; margin-bottom: 0em; }
            .table-of-contents ol { margin: 0em; padding: 1em; line-height: 1.3em; }
            .table-of-contents ol ol { margin: 0em; padding: 0em 1em 0em 1em; }
            .table-of-contents h2 { background: \#ccc; color: \#111; padding: .75em; margin: 0em; border-radius: .5em .5em 0em 0em; }
            nav > ol { margin-top: 0em; }
            nav > ol > li > div > a,
            nav > ol > li > a { display: inline-block; width: calc(100% - 1em); background: \#f6f6f6; padding: .25em .5em .25em .5em; border-radius: .5em; margin: .25em 0em .25em 0em; font-size: 1.2em; color: \#111; border: solid 1pt \#ccc; }
            nav > ol > li > ol > li > a,
            nav > ol > li > ol > li > div > a { color: \#7c0000; }
            nav > ol > li > ol > li > a:hover,
            nav > ol > li > ol > li > div > a:hover { color: \#af6666; }
            nav > ol > li > ol > li > ol > li > a { color: \#00007c; }
            nav > ol > li > ol > li > ol > li > a:hover { color: \#6666af; }
            .center { text-align: center; }
            img { display: block; max-width: 760pt; margin: 1em auto 1em auto; padding: auto; }
            figure { background: \#fcfcfc; border: solid 1pt \#ccc; border-radius: .5em; }
            figcaption { text-align: center;  border-top: solid 1pt \#ccc; border-radius: 0em 0em .5em .5em; background: \#eee; padding: .5em; }
            .chapter { margin: auto auto 1em auto; max-width: 1074pt; min-width: 720pt; width: 850pt; background: \#fff; color: \#111; padding: 0em; border: solid 1pt \#ccc; border-radius: 1em 1em .5em .5em; }
            .chapter p, .chapter pre, .chapter table { padding: 0pt 12pt 0pt 12pt; }
            .chapter h2 { background: \#222; color: \#fff; padding: .75em; margin: 0em; border-radius: .5em .5em 0em 0em; }
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
        ]
    ]
}

// Title page & Table of Contents
// ----------------------------------------------------------------------------
#context if target() == "paged" {
    page(numbering: none)[
        #align(center + horizon)[
            #text(size: 28pt, weight: "bold")[`djehuty`]
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
        #heading(outlined: false)[Table of Contents]
        #outline(
            title: none,
            indent: 1.5em,
            depth: 3,
        )
    ]
}
#context if target() == "html" {
    html.elem("div", attrs: (class: "table-of-contents"))[
        #html.elem("h2")[#html.elem("code")[djehuty]]
        #html.elem("p")[This document is also available as #html.elem("a", attrs: (href: "djehuty.pdf"))[PDF].]
        #outline(
            title: none,
            indent: 1.5em,
            depth: 3,
        )
    ]
}

#set page(numbering: "1")
#counter(page).update(1)

#include "introduction.typ"
#pagebreak(weak: true)
#include "running-djehuty.typ"
#pagebreak(weak: true)
#include "knowledge-graph.typ"
#pagebreak(weak: true)
#include "contributing.typ"
#pagebreak(weak: true)
#include "api.typ"
#pagebreak(weak: true)
#let bib = bibliography("references.bib", style: "apa")
#render_chapter(bib, "Bibliography")
#pagebreak(weak: true)
#include "contact.typ"
#pagebreak(weak: true)
#include "news.typ"

//  begin{html}
//<div id="sidebar" class="narrow"><nav role="menu" aria-label="Navigation" class="sidebarwrap">
//<h2 class="likechapterHead additionalHead"><a href="#news-section">News</a></h2>
//<h2 class="likechapterHead additionalHead"><a href="#contact-section">Contact</a></h2>
//  end{html}
//  renewcommand{\contentsname}{\href{\#titlepage}{Documentation}}
// listoffigures

// <script>
// var windowState = "unset";
// function removeWhitespace (element) {
//   let sibling = element.nextElementSibling;
//   if (sibling != null && sibling.nodeName === "BR") { sibling.remove(); }
//   sibling = element.nextSibling;
//   while (sibling !== element.nextElementSibling) {
//     sibling.remove();
//     sibling = element.nextSibling;
//   }
// }
// function setWindowState (state) {
//   document.getElementById("sidebar").setAttribute("class", (state !== "wide") ? "chapter narrow" : "wide");
//   for (table of document.getElementsByTagName("table")) { table.setAttribute("class", `tabular ${state}`); }
//   for (chapter of document.getElementsByClassName("chapter")) { chapter.setAttribute("class", `chapter ${state}`); }
//   for (section of document.getElementsByClassName("section_subsections")) { section.style.display = (state !== "wide") ? "block" : "none"; }
//   windowState = state;
// }
// function renderWindow (event) {
//   let windowWidth = window.innerWidth;
//   if (windowWidth < 961 && windowState !== "ultra-narrow") {
//     setWindowState ("ultra-narrow");
//   } else if (windowWidth > 960 && windowWidth < 1500 && windowState !== "narrow") {
//     setWindowState ("narrow");
//   } else if (windowWidth > 1499 && windowState !== "wide") {
//     setWindowState ("wide");
//   }
// }
// function setRoleForAnchorInside (element, role) {
//   try {
//     let anchors = element.getElementsByTagName("a");
//     anchors[anchors.length - 1].setAttribute("role", role);
//   } catch (e) {}
// }
// window.addEventListener('load', function () {
//   let sidebar = document.getElementById("sidebar");
//   for (chapter of sidebar.getElementsByClassName("likechapterHead")) {
//     setRoleForAnchorInside (chapter, "menuitem");
//   }
//   for (chapter of sidebar.getElementsByClassName("chapterToc")) {
//     removeWhitespace (chapter);
//     setRoleForAnchorInside (chapter, "menuitem");
//     let chapterNumber = chapter.textContent.split(" ")[0];
//     let sectionsWrapper = document.createElement("div");
//     sectionsWrapper.setAttribute("id", `chapter${chapterNumber}_sections`);
//     sectionsWrapper.setAttribute("class", "chapter_sections");
//     chapter.after(sectionsWrapper);
//   }
//   for (section of document.getElementsByClassName("sectionToc")) {
//     removeWhitespace (section);
//     setRoleForAnchorInside (section, "menuitem");
//     let sectionNumber = section.textContent.split(" ")[0];
//     let chapterNumber = sectionNumber.split(".")[0];
//     let chapterElement = document.getElementById(`chapter${chapterNumber}_sections`);
//     if (section.nextElementSibling != null && section.nextElementSibling.className !== "subsectionToc") {
//       chapterElement.appendChild(section);
//       continue;
//     }
//     let class_name = sectionNumber.split(".").join("_");
//     let subsectionsWrapper = document.createElement("div");
//     subsectionsWrapper.setAttribute("id", `section${class_name}_subsections`);
//     subsectionsWrapper.setAttribute("class", "section_subsections");
//     chapterElement.appendChild(section);
//     chapterElement.appendChild(subsectionsWrapper);
//   }
//   for (subsection of sidebar.getElementsByClassName("subsectionToc")) {
//     removeWhitespace(subsection);
//     setRoleForAnchorInside (subsection, "menuitem");
//     let splitted = subsection.textContent.split(" ")[0].split(".");
//     let class_name = `${splitted[0]}_${splitted[1]}`;
//     let sectionElement = document.getElementById(`section${class_name}_subsections`);
//     sectionElement.appendChild(subsection);
//   }
//   let additionalHeads = document.getElementsByClassName("additionalHead");
//   for (head of additionalHeads) {
//     sibling = head.nextElementSibling;
//     if (sibling != null && sibling.nodeName === "P") {
//       sibling.remove();
//     }
//   }
//   window.addEventListener("resize", renderWindow);
//   renderWindow(null);
// });
// </script>
