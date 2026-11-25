FROM node:24-alpine3.24

# Defining environment variables for both BW and MC cli binaries
ARG BW_CLI_VERSION="2026.11.1"
ARG MC_ARCH="linux-amd64"

# Temporarily using root user to install packages and to write to usr/local/bin
USER root

RUN apk update \
    && apk upgrade --no-cache \
    && apk add --no-cache \
      bash \
      ca-certificates \
      curl \
    &&  node --version \
    &&  npm --version \
# Installing npm to install bw cli and verifying that cli is executable
    && npm install --global  "@bitwarden/cli@${BW_CLI_VERSION}" \
    && bw --version \

# Using curl to download mc cli binary and verifying cli is executable
    && curl --fail --silent --show-error --location --output /usr/local/bin/mc "https://dl.min.io/aistor/mc/release/${MC_ARCH}/mc" \
    && chmod 0755 /usr/local/bin/mc \
    && mc --version \
    && addgroup -S -g 10001 backup \
    && adduser -S -D -H -u 10001 -G backup backup \
    && mkdir -p /work /tmp/mc \
# Creating nonroot system user and group and changing ownership of directories to created system backup user/group
    && chown -R backup:backup /work /tmp/mc

USER 10001:10001

ENV HOME=/work MC_CONFIG_DIR=/tmp/mc

