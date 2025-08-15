ARG VERSION=2
FROM caddy:${VERSION}-alpine

COPY ./amd64/caddy /usr/bin/caddy
RUN chmod +x /usr/bin/caddy

LABEL org.opencontainers.image.authors="github.com/alexandzors"
LABEL org.opencontainers.image.architecture="amd64"