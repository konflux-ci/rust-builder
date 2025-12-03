FROM registry.access.redhat.com/ubi9/ubi:latest AS builder

RUN dnf install --setop install_weak_deps=false --nodocs -y git python gcc g++ cmake rust cargo ninja-build openssl-devel xz

RUN mkdir /build
RUN mkdir /install
RUN mkdir /licenses

COPY build.sh /build/

WORKDIR /build

RUN ./build.sh 1.85.0
RUN ./build.sh 1.85.0 1.86.0
RUN ./build.sh 1.86.0 1.87.0
RUN ./build.sh 1.87.0 1.88.0
RUN ./build.sh 1.88.0 1.89.0
RUN ./build.sh 1.89.0 1.90.0
RUN ./build.sh 1.90.0 1.91.0

FROM registry.access.redhat.com/ubi9/ubi:latest

RUN dnf install -y git python gcc g++ cmake ninja-build openssl-devel npm xz

RUN mkdir /usr/local/lib/rust

COPY --from=builder /install/1.91.0 /usr/local/share/rust
COPY --from=builder /licenses /licenses

ENV PATH=$PATH:/usr/local/share/rust/bin

USER 1001
