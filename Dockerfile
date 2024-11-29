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
FROM gcr.io/distroless/static-debian12:nonroot@sha256:d71f4b239be2d412017b798a0a401c44c3049a3ca454838473a4c32ed076bfea as hcloud-cli-minimal

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]

#-------------------
# Debug image
#-------------------
FROM gcr.io/distroless/static-debian12:debug-nonroot@sha256:a43e6374356eb5e167e0cedc2326dff771d5cd6a84a8efe264c9266d50fddb39 as hcloud-cli-debug

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]
