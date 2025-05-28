[![GitHub license](https://img.shields.io/github/license/rwunderer/hcloud-cli.svg)](https://github.com/rwunderer/hcloud-cli/blob/main/LICENSE)
<a href="https://renovatebot.com"><img alt="Renovate enabled" src="https://img.shields.io/badge/renovate-enabled-brightgreen.svg?style=flat-square"></a>

***As a contribution to [unplug Trump](https://www.kuketz-blog.de/unplugtrump-mach-dich-digital-unabhaengig-von-trump-und-big-tech/) this repository has moved to [codeberg](https://codeberg.org/capercode/hcloud-cli).***

# hcloud-cli
Minimal Docker image with [Hetzner cli utility](https://github.com/hetznercloud/cli)

## Image variants

This image is based on [distroless](https://github.com/GoogleContainerTools/distroless) and comes in two variants:

### Minimal image

The minimal image is based on `gcr.io/distroless/static-debian12:nonroot` and does not contain a shell. It can be directly used from the command line, eg:

```
$ docker run --rm -it ghcr.io/rwunderer/hcloud-cli:v1.38.3-minimal version
hcloud 1.38.3
```

### Debug image

The debug images is based on `gcr.io/distroless/static-debian12:debug-nonroot` and contains a busybox shell for use in ci images.
E.g. for GitLab CI:

```
  image:
    name: ghcr.io/rwunderer/hcloud-cli:v1.38.3-debug@sha256:42e8fc117a48c35b44160a2747b023009cc3ac800012aa8edab04e29e7166c81
    entrypoint: [""]
  variables:
    HCLOUD_TOKEN: ""
  script:
    - hcloud image list
```

## Workflows

| Badge      | Description
|------------|---------
|[![Auto-Tag](https://github.com/rwunderer/hcloud-cli/actions/workflows/renovate-create-tag.yml/badge.svg)](https://github.com/rwunderer/hcloud-cli/actions/workflows/renovate-create-tag.yml) | Automatic Tagging of new hcloud releases
|[![Docker](https://github.com/rwunderer/hcloud-cli/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/rwunderer/hcloud-cli/actions/workflows/docker-publish.yml) | Docker image build
