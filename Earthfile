VERSION 0.6
FROM alpine
ARG BUNDLE
ARG VERSION="latest"
ARG IMAGE_REPOSITORY=ghcr.io/wyvernzora

# renovate: datasource=docker depName=renovate/renovate versioning=docker
ARG RENOVATE_VERSION=37
# renovate: datasource=docker depName=koalaman/shellcheck-alpine versioning=docker
ARG SHELLCHECK_VERSION=v0.9.0

version:
    FROM alpine
    RUN apk add git
    COPY . ./
    RUN echo $(git describe --exact-match --tags || echo "v0.0.0-$(git log --oneline -n 1 | cut -d" " -f1)") > VERSION
    SAVE ARTIFACT VERSION VERSION

build:
    COPY +version/VERSION ./
    ARG VERSION=$(cat VERSION)
    FROM DOCKERFILE -f bundle/${BUNDLE}/Dockerfile ./bundle/${BUNDLE}
    SAVE IMAGE --push $IMAGE_REPOSITORY/kairos-${BUNDLE}:${VERSION}

rootfs:
    FROM +build
    SAVE ARTIFACT /. rootfs

test:
    FROM ghcr.io/wyvernzora/kairos:latest
    RUN apt-get update && apt-get install -y golang
    ENV GOPATH=/go
    ENV PATH=$PATH:$GOPATH/bin
    COPY (+rootfs/rootfs --BUNDLE=$BUNDLE) /bundle
    COPY tests tests
    COPY bundle/${BUNDLE}/tests/* tests/
    RUN cd tests && \
        go install -mod=mod github.com/onsi/ginkgo/v2/ginkgo && \
        ginkgo --label-filter="${BUNDLE}" -v ./...

renovate-validate:
    ARG RENOVATE_VERSION
    FROM renovate/renovate:$RENOVATE_VERSION
    WORKDIR /usr/src/app
    COPY .github/renovate.json .
    RUN renovate-config-validator

shellcheck-lint:
    ARG SHELLCHECK_VERSION
    FROM koalaman/shellcheck-alpine:$SHELLCHECK_VERSION
    WORKDIR /mnt
    COPY . .
    RUN find . -name "*.sh" -print | xargs -r -n1 shellcheck

lint:
    BUILD +renovate-validate
    BUILD +shellcheck-lint

kairos-image:
    BUILD ./image+publish
