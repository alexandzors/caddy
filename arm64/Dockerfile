ARG  VERSION=2.8
FROM arm64v8/caddy:${VERSION}-alpine

COPY ./caddy_arm64 /usr/bin/caddy
RUN chmod +x /usr/bin/caddy

LABEL org.opencontainers.image.authors="github.com/alexandzors"