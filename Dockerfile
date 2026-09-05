FROM ubuntu:24.04


ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8


RUN apt-get update && apt-get install -y \
    build-essential gdb curl git libgmp-dev python3 \
    && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | \
    BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
    BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1 \
    sh

ENV PATH="/root/.ghcup/bin:${PATH}"

RUN ghcup install ghc --set
RUN ghcup install cabal --set
RUN ghcup install hls --set

WORKDIR /workspace