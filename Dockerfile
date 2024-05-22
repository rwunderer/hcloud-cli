#-------------------
# Download hcloud
#-------------------
FROM alpine:3.20.0@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd as builder

# renovate: datasource=github-releases depName=hcloud-cli lookupName=hetznercloud/cli
ARG HCLOUD_VERSION=v1.43.1
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
FROM gcr.io/distroless/static-debian12:nonroot@sha256:e9ac71e2b8e279a8372741b7a0293afda17650d926900233ec3a7b2b7c22a246 as hcloud-cli-minimal

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]

#-------------------
# Debug image
#-------------------
FROM gcr.io/distroless/static-debian12:debug-nonroot@sha256:cb0459bf13af06cb3d3ee5dde5f1c5c34381cbce3a86bd08e1e7fd7a3ed28e59 as hcloud-cli-debug

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]
