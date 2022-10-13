FROM golang:1.16 as cli-builder
WORKDIR /go/src/github.com/mendersoftware/mender-cli
ARG MENDER_CLI_VERSION
RUN if [ -z "$MENDER_CLI_VERSION" ]; then export MENDER_CLI_VERSION=master; fi && \
    git clone -b $MENDER_CLI_VERSION https://github.com/mendersoftware/mender-cli.git . && \
    make get-deps && \
    make build

FROM golang:1.18 as artifact-builder
WORKDIR /go/src/github.com/mendersoftware/mender-artifact
ARG MENDER_ARTIFACT_VERSION
RUN if [ -z "$MENDER_ARTIFACT_VERSION" ]; then export MENDER_ARTIFACT_VERSION=master; fi && \
    git clone -b $MENDER_ARTIFACT_VERSION https://github.com/mendersoftware/mender-artifact.git . && \
    apt-get update && \
    apt-get install -y gcc gcc-mingw-w64 gcc-multilib musl-dev liblzma-dev libssl-dev && \
    make build

FROM alpine
COPY --from=cli-builder /go/src/github.com/mendersoftware/mender-cli /usr/bin/
COPY --from=artifact-builder /go/src/github.com/mendersoftware/mender-artifact/mender-artifact /usr/bin/
RUN apk add --no-cache libc6-compat xz-dev libressl-dev
