#-------------------
# Download hcloud
#-------------------
FROM alpine:3.21.2@sha256:56fa17d2a7e7f168a043a2712e63aed1f8543aeafdcee47c58dcffe38ed51099 AS builder

# renovate: datasource=github-releases depName=hcloud-cli lookupName=hetznercloud/cli
ARG HCLOUD_VERSION=v1.50.0
ARG TARGETARCH
ARG TARGETOS
ARG TARGETVARIANT

WORKDIR /tmp

RUN apk --no-cache add --upgrade \
    curl

RUN IMAGE=hcloud-${TARGETOS}-${TARGETARCH}${TARGETVARIANT}.tar.gz && \
    curl -SsL -o ${IMAGE} https://github.com/hetznercloud/cli/releases/download/${HCLOUD_VERSION}/${IMAGE} && \
    tar xzf ${IMAGE} hcloud && \
    install hcloud /bin && \
    rm ${IMAGE} hcloud

#-------------------
# Minimal image
#-------------------
FROM gcr.io/distroless/static-debian12:nonroot@sha256:6ec5aa99dc335666e79dc64e4a6c8b89c33a543a1967f20d360922a80dd21f02 AS hcloud-cli-minimal

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]

#-------------------
# Debug image
#-------------------
FROM gcr.io/distroless/static-debian12:debug-nonroot@sha256:9aca3e7de7bddd3f5d5a7192c4f8aeeba770f72bd61186841d47038e5b388daf AS hcloud-cli-debug

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]
