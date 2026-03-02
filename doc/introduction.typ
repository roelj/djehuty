#import "config.typ": *

#let chapter_text = [
= Introduction

`djehuty` is a data and software repository system. The name finds its
inspiration in #link("https://en.wikipedia.org/wiki/Thoth")[Thoth], the Egyptian
entity that introduced the idea of writing.

== Obtaining the source code <sec-obtaining-tarball>

The source code can be downloaded at the
#link(djehutygiturl + "/releases")[Releases]#footnote(djehutygiturl + "/releases")
page. Make sure to download the `djehuty-#djehutyversion.tar.gz` file.

Or, directly download the tarball using the command-line:

#let output = ```bash
curl -LO <djehutygiturl>/releases/download/v<djehutyversion>/djehuty-<djehutyversion>.tar.gz
```
#render_code_output(output)

After obtaining the tarball, it can be unpacked using the `tar` command:

#let output = ```bash
tar zxvf djehuty-<djehutyversion>.tar.gz
```
#render_code_output(output)

== Installing the prerequisites <sec-prerequisites>

The `djehuty` program needs Python (version 3.9 or higher) and
Git to be installed. Additionally, a couple of Python packages need
to be installed. The following sections describe installing the
prerequisites on various GNU/Linux distributions. To put the software in
the context of its environment, @fig-references-graph displays
the complete run-time dependencies from `djehuty` to `glibc`.

#figure(
  image("figures/references-graph.svg"),
  caption: [Run-time references when constructed with the packages from GNU Guix.],
) <fig-references-graph>

The web service of `djehuty` stores its information in a SPARQL 1.1
@sparql-11 endpoint. We recommend either
#link("https://blazegraph.com/")[Blazegraph]#footnote("https://blazegraph.com/")
or #link("http://vos.openlinksw.com/owiki/wiki/VOS")[Virtuoso open-source edition]#footnote("http://vos.openlinksw.com/owiki/wiki/VOS").

=== Optional installation requirements depending on configuration

For specific features `djehuty` may require additional packages to be
installed. Whether this is the case depends on the run-time configuration.
When an optional package is required `djehuty` will report which one in
its logs. There are three configuration scenarios that require the
additional packages: SAML, S3 and IIIF.

==== SAML

When configuring the use of an identity provider via SAML `djehuty`
requires the `python3-saml` Python package to be installed. This
package provides the implementation of the SAML protocol.

==== S3

When configuring file access in S3 buckets `djehuty` requires the
`boto3` Python package to be installed. This package is used to
authenticate to the S3 endpoints and to download (or stream) data.

==== IIIF

When enabling the IIIF functionality `djehuty` requires the
`pyvips` Python package to be installed. This package is used to
perform image transformations.

== Installation instructions

After obtaining the source code (see @sec-obtaining-tarball)
and installing the required tools (see @sec-prerequisites),
building involves running the following commands:

#let output = ```bash
cd djehuty-<djehutyversion>
autoreconf -vif # Only needed if the "./configure" step does not work.
./configure
make
make install
```
#render_code_output(output)

To run the `make install` command, super user privileges may be
required. Specify a `--prefix` to the `configure`
script to install the tools to a user-writeable location to avoid
needing super user privileges.

After installation, the `djehuty` program will be available.

== Pre-built containers

Docker container images are provided as a convenience service
for each monthly `djehuty` release. The following table outlines the
meaning of each image provided. The images are published to
#link("https://hub.docker.com/r/4turesearchdata/djehuty")[Docker Hub]#footnote("https://hub.docker.com/r/4turesearchdata/djehuty").

#table(
  columns: (auto, 1fr),
  table.header([*Image tag*], [*Description*]),
  [`devel`],
  [Image meant for development purposes. Before it executes the `djehuty`
   command it checks out the latest codebase. So re-running the same container
   image may result in running a different version of `djehuty`.],
  [`latest`],
  [This image points to the latest `djehuty` release. It does not automatically
   update the `djehuty` codebase.],
  [`XX.X`],
  [Release number where the number before the dot refers to the year and the
   number after the dot refers to the month. Use a specific version image when
   you want to upgrade at your own pace.],
)

To build the container images for yourself, see the build instructions in
the `docker/Dockerfile` file.

== RPM packages

RPM packages are provided and built for Enterprise Linux 10. This
RPM depends on packages in the
#link("https://docs.fedoraproject.org/en-US/epel")[Extra Packages for Enterprise Linux (EPEL)]
repository.

#table(
  columns: (auto, 1fr),
  table.header([*Filename*], [*Description*]),
    [#link(djehutygiturl + "/releases/download/v" + djehutyversion + "/djehuty-" + djehutyversion + "-1.el10.noarch.rpm")[djehuty-#(djehutyversion)-1.el10.noarch.rpm]],
  [Binary RPM, to install and run `djehuty`.],
    [#link(djehutygiturl + "/releases/download/v" + djehutyversion + "/djehuty-" + djehutyversion + "-1.el10.src.rpm")[djehuty-#(djehutyversion)-1.el10.src.rpm]],
  [Source RPM, to (re)build from source code.],
)

RPM packages for more distributions, including Enterprise Linux 9, are
#link("https://copr.fedorainfracloud.org/coprs/4turesearchdata/djehuty")[built via Copr].

== Debian packages

Debian packages are provided and built for Debian 13.
#table(
  columns: (auto, 1fr),
  table.header([*Filename*], [*Description*]),
    [#link(djehutygiturl + "/releases/download/v" + djehutyversion + "/djehuty-" + djehutyversion + ".deb")[djehuty-#(djehutyversion)\.deb]],
  [Binary DEB, to install and run `djehuty`.],
    [#link(djehutygiturl + "/releases/download/v" + djehutyversion + "/djehuty-" + djehutyversion + ".src.deb")[djehuty-#(djehutyversion)\.src\.deb]],
  [Source DEB, to (re)build from source code.],
)

]

#render_chapter(chapter_text, "Introduction")
