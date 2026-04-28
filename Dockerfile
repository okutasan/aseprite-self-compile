# Menggunakan Ubuntu 22.04 (Jammy) untuk kompatibilitas dependencies
FROM ubuntu:22.04

# Set non-interactive agar instalasi tidak nyangkut minta input zona waktu
ENV DEBIAN_FRONTEND=noninteractive

# Menentukan versi Aseprite dan Skia
ENV ASEPRITE_VERSION=v1.3.17
ENV SKIA_VERSION=m124-08a5439a6b

# Install semua build dependencies yang dibutuhkan
RUN apt-get update && apt-get install -y \
    g++ clang cmake ninja-build \
    libx11-dev libxcursor-dev libxi-dev libxrandr-dev \
    libgl1-mesa-dev libfontconfig1-dev curl unzip git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# 1. Download & Extract Aseprite Source Code
RUN curl -LO "https://github.com/aseprite/aseprite/releases/download/${ASEPRITE_VERSION}/Aseprite-${ASEPRITE_VERSION}-Source.zip" && \
    unzip "Aseprite-${ASEPRITE_VERSION}-Source.zip" -d aseprite && \
    rm "Aseprite-${ASEPRITE_VERSION}-Source.zip"

# 2. Download & Extract Pre-built Skia (wajib untuk Aseprite UI backend)
RUN curl -LO "https://github.com/aseprite/skia/releases/download/${SKIA_VERSION}/Skia-Linux-Release-x64.zip" && \
    unzip Skia-Linux-Release-x64.zip -d skia && \
    rm Skia-Linux-Release-x64.zip

# 3. Proses Build menggunakan CMake dan Ninja
WORKDIR /build/aseprite/build
RUN export CC=clang && export CXX=clang++ && \
    cmake \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_CXX_FLAGS:STRING=-stdlib=libstdc++ \
    -DCMAKE_EXE_LINKER_FLAGS:STRING=-stdlib=libstdc++ \
    -DLAF_BACKEND=skia \
    -DSKIA_DIR=/build/skia \
    -DSKIA_LIBRARY_DIR=/build/skia/out/Release-x64 \
    -DSKIA_LIBRARY=/build/skia/out/Release-x64/libskia.a \
    -G Ninja .. && \
    ninja aseprite

# 4. Bikin Portable Archive
WORKDIR /build
# Folders di dalam bin/ sudah memuat executable dan data/ resource yang dibutuhkan
RUN tar -czvf aseprite-portable-linux.tar.gz -C /build/aseprite/build/bin .

CMD ["/bin/bash"]