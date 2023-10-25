#-------------------
# Download hcloud
#-------------------
FROM alpine:3.18.4@sha256:eece025e432126ce23f223450a0326fbebde39cdf496a85d8c016293fc851978 as builder

# renovate: datasource=github-releases depName=hcloud-cli lookupName=hetznercloud/cli
ARG HCLOUD_VERSION=v1.39.0
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
FROM gcr.io/distroless/static-debian12:nonroot@sha256:43a5ce527e9def017827d69bed472fb40f4aaf7fe88c356b23556a21499b1c04 as hcloud-cli-minimal

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]

#-------------------
# Debug image
#-------------------
FROM gcr.io/distroless/static-debian12:debug-nonroot@sha256:12f9bf5f9955ae90e619520e58eeba839a7ec959e051a62a780de447f38d65ed as hcloud-cli-debug

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]
