FROM debian:trixie-slim
LABEL authors="Nikhef, 4TU.ResearchData, Roel Janssen"
ARG PURPOSE="release"
ARG BRANCH="main"
ARG VERSION="0.0.0"
ARG GIT_URL="https://codeberg.org/seshat/seshat.git"

# Build a self-updating (development) container:
# docker image build --build-arg="PURPOSE=development" -t seshat:devel .
#
# Or a non-self-updating (release) container:
# docker image build -t seshat:latest .
#
# start with: docker container run --rm -ti -v ../etc/seshat/seshat-example-config.xml:/config.xml:Z seshat:latest /bin/seshat web -c /config.xml

RUN apt-get update \
    && apt-get install -y autoconf automake make git python3 python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/dpkg/info/*.list /var/lib/apt/lists/* \
    && useradd -mg users -d /opt/seshat -u 7001 seshat \
    && mkdir -p /data && chown -R seshat: /data \
    &&  echo '#!/bin/sh\n/usr/bin/git -C /opt/seshat/seshat pull\nGIT_VERSION=$(git -C /opt/seshat/seshat rev-parse --short HEAD)\nsed -i "s|AC_INIT|AC_INIT(seshat, 0.0.dev0+t${GIT_VERSION}) dnl AC_INIT|g" /opt/seshat/seshat/configure.ac\ncd /opt/seshat/seshat; autoreconf -if && ./configure\nVIRTUAL_ENV=/opt/seshat/virtual-env\n/opt/seshat/virtual-env/bin/pip install --editable /opt/seshat/seshat\n' > /usr/bin/update-seshat \
    && chmod +x /usr/bin/update-seshat \
    && UPDATE_COMMAND=""; if [ "$PURPOSE" = "development" ]; then UPDATE_COMMAND="/usr/bin/update-seshat"; fi; echo '#!/bin/sh\n'${UPDATE_COMMAND}'\nVIRTUAL_ENV=/opt/seshat/virtual-env\n/opt/seshat/virtual-env/bin/seshat $@' > /usr/bin/seshat && chmod +x /usr/bin/seshat

USER seshat

RUN git clone --branch "$BRANCH" --depth 1 "$GIT_URL" /opt/seshat/seshat \
    && GIT_VERSION=$(git -C /opt/seshat/seshat rev-parse --short HEAD); cd /opt/seshat/seshat; autoreconf -if && ./configure \
    && python3 -m venv /opt/seshat/virtual-env \
    && . /opt/seshat/virtual-env/bin/activate \
    && pip install python3-saml --editable /opt/seshat/seshat

CMD ["/bin/bash"]
