ARG VERSION=2
FROM --platform=$BUILDPLATFORM caddy:${VERSION}-alpine

ARG TARGETARCH
COPY ./amd64/caddy /usr/bin/caddy-amd64
COPY ./arm64/caddy_arm64 /usr/bin/caddy-arm64

RUN if [ "$TARGETARCH" = "amd64" ]; then mv /usr/bin/caddy-amd64 /usr/bin/caddy; \
    elif [ "$TARGETARCH" = "arm64" ]; then mv /usr/bin/caddy-arm64 /usr/bin/caddy; fi
RUN chmod +x /usr/bin/caddy

LABEL org.opencontainers.image.authors="github.com/alexandzors"