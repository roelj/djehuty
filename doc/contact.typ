#import "config.typ": *
#let chapter_text = [
#silent-chapter[Contact] <contact>

#silent-section[The team]

This software is voluntarily maintained by
#link("mailto:symmetricbutterfly@proton.me")[Malaika Newman],
#link("mailto:rrejanssen@gmail.com")[Roel Janssen] and
#link("mailto:emualliugdb@gmail.com")[Guillaume Dubois].

#silent-section[Mailing lists]

You can best reach us through the #link("https://djehuty.roelj.com/postorius/lists/devel.djehuty.roelj.com/")[development mailing list],
which we use for all communication regarding the project.

#silent-section[Reporting security vulnerabilities] <reporting-security-vulnerabilities>

For security-related matters, please e-mail
#link("mailto:security@djehuty.roelj.com")[security\@djehuty.roelj.com].
]

#render_chapter(chapter_text, "Contact")
