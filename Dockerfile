#-------------------
# Download hcloud
#-------------------
FROM busybox:v1.36.1@sha256:3fbc632167424a6d997e74f52b878d7cc478225cffac6bc977eedfe51c7f4e79 as builder

# renovate: datasource=github-releases depName=hcloud-cli lookupName=hetznercloud/cli
ARG HCLOUD_VERSION=v1.38.3
ARG TARGETARCH
ARG TARGETOS
ARG TARGETVARIANT

WORKDIR /tmp

#RUN wget https://github.com/hetznercloud/cli/releases/download/${HCLOUD_VERSION}/hcloud-${TARGETOS}-${TARGETARCH}${TARGETVARIANT}.tar.gz && \
#    tar xzf hcloud-${TARGETOS}-${TARGETARCH}${TARGETVARIANT}.tar.gz hcloud && \
#    install hcloud /bin && \
#    rm hcloud-${TARGETOS}-${TARGETARCH}${TARGETVARIANT}.tar.gz hcloud
RUN touch /bin/hcloud

#-------------------
# Minimal image
#-------------------
FROM gcr.io/distroless/static-debian12@sha256:0c3d36f317d6335831765546ece49b60ad35933250dc14f43f0fd1402450532e as hcloud-cli-minimal

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]

#-------------------
# Debug image
#-------------------
FROM gcr.io/distroless/static-debian12:debug@sha256:fab2e9501d6f4748474dc64d58225bca9508cb0c6f8b3a45fee7d633afd87c1a as hcloud-cli-debug

COPY --from=builder /bin/hcloud /bin/hcloud

ENTRYPOINT ["/bin/hcloud"]
