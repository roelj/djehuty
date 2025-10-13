"""
This module provides constants that can be used throughout
the codebase.
"""

filetypes_by_extension = {
    "bash":       "Shell",
    "bib":        "TeX",
    "c":          "C",
    "cc":         "C++",
    "cpp":        "C++",
    "cs":         "C#",
    "css":        "CSS",
    "cxx":        "C++",
    "d":          "D",
    "f":          "Fortran",
    "f77":        "Fortran",
    "f90":        "Fortran",
    "for":        "Fortran",
    "geojson":    "JSON",
    "go":         "Go",
    "gohtml":     "Go",
    "h":          "C",
    "hpp":        "C++",
    "hs":         "Haskell",
    "html":       "HTML",
    "htm":        "HTML",
    "hxx":        "C++",
    "in":         "Automake",
    "ipynb":      "Jupyter Notebook",
    "java":       "Java",
    "jl":         "Julia",
    "js":         "JavaScript",
    "json":       "JSON",
    "m":          "Matlab",
    "mat":        "Matlab",
    "md":         "Markdown",
    "mts":        "TypeScript",
    "mysql":      "SQL",
    "php":        "PHP",
    "pl":         "Perl",
    "pm":         "Perl",
    "py":         "Python",
    "r":          "R",
    "rb":         "Ruby",
    "rs":         "Rust",
    "sh":         "Shell",
    "sparql":     "SPARQL",
    "sql":        "SQL",
    "sty":        "TeX",
    "tex":        "TeX",
    "ts":         "TypeScript",
    "tsx":        "TypeScript",
    "xml":        "XML",
    "xyz":        "Chemical XYZ",
    "yaml":       "YAML",
    "yml":        "YAML",
}

allowed_html_tags = ["p", "strong", "em", "u", "ol", "ul", "li", "code", "pre", "br", "sup", "sub", "h2", "h3"]

iiif_supported_formats = [ ".jpg", ".png", ".pdf", ".tif", ".tiff", ".gif", ".webp" ]
datetime_format = "%Y-%m-%dT%H:%M:%S"  # pylint: disable=invalid-name
