#-------------------
# Download hcloud
#-------------------
FROM alpine:3.20.3@sha256:1e42bbe2508154c9126d48c2b8a75420c3544343bf86fd041fb7527e017a4b4a as builder

# renovate: datasource=github-releases depName=hcloud-cli lookupName=hetznercloud/cli
ARG HCLOUD_VERSION=v1.49.0
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
FROM gcr.io/distroless/static-debian12:nonroot@sha256:3a03fc0826340c7deb82d4755ca391bef5adcedb8892e58412e1a6008199fa91 as hcloud-cli-minimal

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]

#-------------------
# Debug image
#-------------------
FROM gcr.io/distroless/static-debian12:debug-nonroot@sha256:e1b3e6d4f72cf1c29a21fe79767c7c9e206ed8e05467b4677b80bad1219a00c3 as hcloud-cli-debug

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]
