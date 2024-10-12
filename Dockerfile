# Use Ubuntu 23.04 as the base image
FROM ubuntu:23.04

# Install general development tools and any other needed dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    sudo \
    wget \
    pkg-config \
    coreutils \
    findutils \
    tar \
    grep \
    file \
    gzip \
    bzip2 \
    xz-utils \
    brotli \
    lz4 \
    lzop \
    pigz \
    lbzip2 \
    libncurses5-dev \
    libncursesw5-dev \
    libudev-dev \
    libdrm-dev


# Set up a directory for the build
WORKDIR /build

# Entrypoint to run a specified script
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["echo 'Specify a build script to run'"]
