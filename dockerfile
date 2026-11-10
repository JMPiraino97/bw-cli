FROM alpine:3.24

# Defining environment variables for both BW and MC cli binaries
ARG BW_CLI_VERSION="2026.10.1"
ARG MC_VERSION="RELEASE.2025-08-13T08-35-41Z"
ARG MC_ARCH="amd64"

# Temporarily using root user to install packages and to write to usr/local/bin
USER root

RUN apk add --no-cache \
      bash \
      ca-certificates \
      curl \
      nodejs \
      npm \
# Installing npm to install bw cli and verifying that cli is executable
    && npm install --global  "@bitwarden/cli@${BW_CLI_VERSION}" \
    && bw --version \

# Using curl to download mc cli binary and verifying cli is executable
    && curl --fail --silent --show-error --location --output /usr/local/bin/mc "https://github.com/minio/mc/releases/download/${MC_VERSION}/mc.${MC_VERSION}.linux-${MC_ARCH}" \
    && chmod 755 /usr/local/bin/mc \
    && mc --version \
    && addgroup -S -g 10001 backup \
    && adduser -S -D -H -u 10001 -G backup backup \
    && mkdir -p /work /tmp/mc \
# Creating nonroot system user and group and changing ownership of directories to created system backup user/group
    && chown -R backup:backup /work /tmp/mc
    
USER 10001:10001

ENV HOME=/work MC_CONFIG_DIR=/tmp/mc

