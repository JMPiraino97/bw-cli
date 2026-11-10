FROM alpine:3.24
ARG BW_CLI_VERSION="2026.10.1"
ARG MC_VERSION="RELEASE.2025-08-13T08-35-41Z"
ARG MC_ARCH="amd64"
RUN apk add --no-cache \
      bash \
      ca-certificates
      curl \
      nodejs \
      npm \
    && npm install --global  "@bitwarden/cli@${BW_CLI_VERSION}"
    && bw --version

RUN curl --fail --silent --show-error --location --output /usr/local/bin/mc "https://github.com/minio/mc/releases/download/${MC_VERSION}/mc.${MC_VERSION}.linux-${MC_ARCH}"
    && chmod 755 /usr/local/bin/mc
    && mc --version
    