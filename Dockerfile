FROM busybox:v1.36.1@sha256:3fbc632167424a6d997e74f52b878d7cc478225cffac6bc977eedfe51c7f4e79

ARG _VERSION=1.38.3
ARG _ARCH=amd64

WORKDIR /tmp

RUN wget https://github.com/hetznercloud/cli/releases/download/v${_VERSION}/hcloud-linux-${_ARCH}.tar.gz && \
    tar xzf hcloud-linux-${_ARCH}.tar.gz hcloud && \
    install hcloud /bin && \
    rm hcloud-linux-${_ARCH}.tar.gz hcloud

ENTRYPOINT ["/bin/hcloud"]
