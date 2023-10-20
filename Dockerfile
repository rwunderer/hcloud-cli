FROM busybox:v1.36.1@sha256:3fbc632167424a6d997e74f52b878d7cc478225cffac6bc977eedfe51c7f4e79

# renovate: datasource=github-releases depName=hcloud-cli lookupName=hetznercloud/cli
ARG HCLOUD_VERSION=1.38.2
ARG ARCH=amd64

WORKDIR /tmp

RUN wget https://github.com/hetznercloud/cli/releases/download/v${HCLOUD_VERSION}/hcloud-linux-${ARCH}.tar.gz && \
    tar xzf hcloud-linux-${ARCH}.tar.gz hcloud && \
    install hcloud /bin && \
    rm hcloud-linux-${ARCH}.tar.gz hcloud

ENTRYPOINT ["/bin/hcloud"]
