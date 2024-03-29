ARG DEBUG_IMAGE
# Build is required to extract the release files
FROM --platform=linux/amd64 debian:bullseye-slim AS build

ARG ROUTER_RELEASE=latest

WORKDIR /dist

# Install curl
RUN \
  apt-get update -y \
  && apt-get install -y \
    curl \
  && rm -rf /var/lib/apt/lists/*

# Run the Router downloader which puts Router into current working directory
RUN curl -sSL https://router.apollo.dev/download/nix/${ROUTER_RELEASE}/ | sh

# Make directories for config and schema
RUN mkdir config schema

# Copy configuration for docker image
COPY /router.yaml config

# Copy over rhai scripts for customizations
COPY /rhai/scripts /dist/rhai/scripts


# Required so we can copy in libz.so.1
FROM --platform=linux/amd64 gcr.io/distroless/java17-debian11${DEBUG_IMAGE} as libz-required

# Final image uses distroless
FROM --platform=linux/amd64 gcr.io/distroless/cc-debian11${DEBUG_IMAGE}

LABEL org.opencontainers.image.authors="Apollo Graph, Inc. https://github.com/apollographql/router"

# Copy in the extracted/created files
COPY --from=libz-required /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1

WORKDIR /dist

# Copy in the extracted/created files
COPY --from=build --chown=root:root /dist .

ENV APOLLO_ROUTER_CONFIG_PATH="/dist/config/router.yaml"
ENV APOLLO_GRAPH_REF ${APOLLO_GRAPH_REF}
ENV APOLLO_KEY ${APOLLO_KEY}

# Default executable is the router
ENTRYPOINT ["/dist/router"]