ARG DESTDIR='/artifacts' UBUNTU_LTS='22.04'

FROM ubuntu:${UBUNTU_LTS} AS builder

ARG DEBIAN_FRONTEND='noninteractive' \
    BUILDDIR='/build' \
    DESTDIR

RUN apt-get update && apt-get upgrade && \
    apt-get -y install \
        libboost-container-dev libfuse-dev libarchive-dev \
        g++ pkg-config make pandoc \
        python3

COPY --link . "${BUILDDIR}"
WORKDIR "${BUILDDIR}"

RUN make

RUN mkdir -v -p "${DESTDIR}" && make install-strip

VOLUME "${DESTDIR}"

FROM ubuntu:${UBUNTU_LTS} AS final

ARG DESTDIR

COPY --from=builder "${DESTDIR}" /
