#import "config.typ": *

#let chapter_text = [
= Knowledge graph

Djehuty processes its information using the Resource Description
Framework @Lassila-99-RDF. This chapter describes the parts that
make up the data model of `djehuty`.

This chapter dives into the structure of the data model, but does not
describe every property. When running an instance of `djehuty`,
the "Exploratory" available in the "Admin panel" can be used to explore
every property.

== Use of vocabularies

Throughout this chapter, abbreviated references to ontologies are used.
@table-vocabularies lists these abbreviations.

#figure(
  table(
    columns: (auto, 1fr),
    table.header([*Abbreviation*], [*Ontology URI*]),
    [`djht`], [Internal and unpublished ontology.],
    [`rdf`],  [#link("http://www.w3.org/1999/02/22-rdf-syntax-ns#")],
    [`rdfs`], [#link("http://www.w3.org/2000/01/rdf-schema#")],
    [`xsd`],  [#link("http://www.w3.org/2001/XMLSchema#")],
  ),
  caption: [Lookup table for vocabulary URIs and their abbreviations.],
) <table-vocabularies>

== Notational shortcuts

In addition to abbreviating ontologies with their prefix we use another
notational shortcut. To effectively communicate the structure of the RDF
graph used by `djehuty` we introduce a couple of shorthand notations.

=== Notation for typed triples

When the `object` in a triple is _typed_, we introduce the shorthand
to only show the type, rather than the actual value of the `object`.
@fig-typed-notation displays this for URIs, and @fig-typed-literals-notation
displays this for literals.

#figure(
  image("figures/typed-notation.svg"),
  caption: [Shorthand notation for triples with an `rdf:type` which features
    a hollow predicate arrow and a colored type specifier with rounded corners.],
) <fig-typed-notation>

Literals are depicted by rectangles (with sharp edges) in contrast to URIs
which are depicted as rectangles with rounded edges.

#figure(
  image("figures/typed-literals-notation.svg"),
  caption: [Shorthand notation for triples with a literal, which features a
    hollow predicate arrow and a colored rectangular type specifier.],
) <fig-typed-literals-notation>

When the subject of a triple is the shorthand type, assume the subject is not
the type itself but the subject which has that type.

=== Notation for `rdf:List`

To preserve the order in which lists were formed, the data model makes use
of `rdf:List` with numeric indexes. This pattern will be abbreviated
in the remainder of the figures as displayed in @fig-rdf-list-abbrev.

#figure(
  image("figures/rdf-list-abbrev.svg"),
  caption: [Shorthand notation for `rdf:List` with numeric indexes, which
    features a hollow double-arrow. Lists have arbitrary lengths, and the
    numeric indexes use 1-based indexing.],
) <fig-rdf-list-abbrev>

The hollow double-arrow depicts the use of an `rdf:List` with numeric indexes.

== Datasets

Datasets play a central role in the repository system because every
other type links in one way or another to it. The user submits
files along with data about those bytes as a single record which we
call a `djht:Dataset`. @fig-dataset shows how the remainder of types
in this chapter relate to a `djht:Dataset`.

#figure(
  image("figures/dataset.svg"),
  caption: [The RDF pattern for a `djht:Dataset`. For a full overview of
    `djht:Dataset` properties, use the exploratory from the administration panel.],
) <fig-dataset>

Datasets are versioned records. The data and metadata between versions
can differ, except all versions of a dataset share an identifier. We use
`djht:DatasetContainer` to describe the version-unspecific properties
of a set of versioned datasets.

#figure(
  image("figures/dataset-container.svg"),
  caption: [The RDF pattern for a `djht:DatasetContainer`. All versions of a
    dataset share a `djht:dataset_id` and a UUID in the container URI.],
) <fig-dataset-container>

The data model follows a natural expression of published versions as a
linked list. @fig-dataset-container further reveals that
the _view_, _download_, _share_ and _citation_ counts are stored
in a version-unspecific way.

== Collections

Collections provide a way to group `djht:Dataset` objects.

#figure(
  image("figures/collection.svg"),
  caption: [The RDF pattern for a `djht:Collection`. For a full overview of
    `djht:Collection` properties, use the exploratory from the administration panel.],
) <fig-collection>

Collections are (just like Datasets) versioned records. The metadata between
versions can differ, except all versions of a collection share an identifier.
We use `djht:CollectionContainer` to describe the version-unspecific
properties of a set of versioned collections.

#figure(
  image("figures/collection-container.svg"),
  caption: [The RDF pattern for a `djht:CollectionContainer`. All versions of a
    collection share a `djht:collection_id` and a UUID in the container URI.],
) <fig-collection-container>

The data model follows a natural expression of published versions as a
linked list. @fig-collection-container further reveals that
the _view_, _download_, _share_ and _citation_ counts are stored
in a version-unspecific way.

== Authors

`djehuty` keeps records of authors including their full name, ORCID,
and e-mail address. Furthermore, each `djht:Account` has a linked
`djht:Author` record.

#figure(
  image("figures/author.svg"),
  caption: [The RDF pattern for a `djht:Author`.],
) <fig-author>

== Accounts

`djehuty` uses an external identity provider, but stores an e-mail address,
full name, and preferences for categories.

#figure(
  image("figures/account.svg"),
  caption: [The RDF pattern for a `djht:Account`.],
) <fig-account>

== Funding

When the `djht:Dataset` originated out of a funded project, the funders
can be listed using `djht:Funding`. @fig-funding displays
the details for this structure.

#figure(
  image("figures/funding.svg"),
  caption: [The RDF pattern for a `djht:Funding`.],
) <fig-funding>

== Categories

Categories in `djehuty` are a controlled vocabulary based on the
#link("https://www.abs.gov.au/Ausstats/abs@.nsf/Latestproducts/4AE1B46AE2048A28CA25741800044242")[Australian and New Zealand Standard Research Classification (ANZSRC)].
The hierarchical structure is captured by using `id` and `parent_id` properties.

#figure(
  image("figures/category.svg"),
  caption: [The RDF pattern for a `djht:Category`.],
) <fig-category>

== Institutions/groups

A `djht:Account` has an affiliation with an institute or research group.
The `djht:InstitutionGroup` is stored per `djht:Dataset` and
`djht:Collection`. The groups can be structured hierarchically by
using the `id` and `parent_id` properties.

#figure(
  image("figures/institutiongroup.svg"),
  caption: [The RDF pattern for a `djht:InstitutionGroup`.],
) <fig-institutiongroup>

== Files

A `djht:Dataset` keeps a list of `djht:File` records. The file
metadata is stored in the knowledge graph while the file contents are
stored on a filesystem. The location of the file data is tracked via the
`djht:filesystem_location` property.

#figure(
  image("figures/file.svg"),
  caption: [The RDF pattern for a `djht:File`.],
) <fig-file>

== Private links

Before a `djht:Dataset` or a `djht:Collection` is made publically
available, it can be shared using a private link.

#figure(
  image("figures/privatelink.svg"),
  caption: [The RDF pattern for a `djht:PrivateLink`.],
) <fig-privatelink>

@fig-privatelink displays how private links are stored for
a `djht:Dataset`, and it works the same for a `djht:Collection`.

== Collaborators

To enable multiple accounts collaborating on a dataset before it's published,
each `djht:Dataset` can have a list of `djht:Collaborator` objects.

#figure(
  image("figures/collaborators.svg"),
  caption: [The RDF pattern for a `djht:Collaborator`.],
) <fig-collaborators>

As shown in @fig-collaborators, a `djht:Collaborator` can be
given read, edit, and/or remove rights independently for both metadata (the
form fields) and data (the files).
]

#render_chapter(chapter_text, "Knowledge graph")
