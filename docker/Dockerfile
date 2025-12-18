FROM debian:trixie-slim
LABEL authors="Nikhef, 4TU.ResearchData, Roel Janssen"
ARG PURPOSE="release"
ARG BRANCH="main"
ARG VERSION="0.0.0"
ARG GIT_URL="https://codeberg.org/roelj/djehuty.git"

# Build a self-updating (development) container:
# docker image build --build-arg="PURPOSE=development" -t djehuty:devel .
#
# Or a non-self-updating (release) container:
# docker image build -t djehuty:latest .
#
# start with: docker container run --rm -ti -v ../etc/djehuty/djehuty-example-config.xml:/config.xml:Z djehuty:latest /bin/djehuty web -c /config.xml

RUN apt-get update \
    && apt-get install -y autoconf automake make git python3 python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/dpkg/info/*.list /var/lib/apt/lists/* \
    && useradd -mg users -d /opt/djehuty -u 7001 djehuty \
    && mkdir -p /data && chown -R djehuty: /data \
    &&  echo '#!/bin/sh\n/usr/bin/git -C /opt/djehuty/djehuty pull\nGIT_VERSION=$(git -C /opt/djehuty/djehuty rev-parse --short HEAD)\nsed -i "s|AC_INIT|AC_INIT(djehuty, 0.0.dev0+t${GIT_VERSION}) dnl AC_INIT|g" /opt/djehuty/djehuty/configure.ac\ncd /opt/djehuty/djehuty; autoreconf -if && ./configure\nVIRTUAL_ENV=/opt/djehuty/virtual-env\n/opt/djehuty/virtual-env/bin/pip install --editable /opt/djehuty/djehuty\n' > /usr/bin/update-djehuty \
    && chmod +x /usr/bin/update-djehuty \
    && UPDATE_COMMAND=""; if [ "$PURPOSE" = "development" ]; then UPDATE_COMMAND="/usr/bin/update-djehuty"; fi; echo '#!/bin/sh\n'${UPDATE_COMMAND}'\nVIRTUAL_ENV=/opt/djehuty/virtual-env\n/opt/djehuty/virtual-env/bin/djehuty $@' > /usr/bin/djehuty && chmod +x /usr/bin/djehuty

USER djehuty

RUN git clone --branch "$BRANCH" --depth 1 "$GIT_URL" /opt/djehuty/djehuty \
    && GIT_VERSION=$(git -C /opt/djehuty/djehuty rev-parse --short HEAD); cd /opt/djehuty/djehuty; autoreconf -if && ./configure \
    && python3 -m venv /opt/djehuty/virtual-env \
    && . /opt/djehuty/virtual-env/bin/activate \
    && pip install python3-saml --editable /opt/djehuty/djehuty

CMD ["/bin/bash"]
