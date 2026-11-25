FROM alpine3.24

# Defining environment variables for both BW and MC cli binaries
ARG BW_CLI_VERSION="2026.11.1"

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

