FROM caddy:alpine

COPY ./caddy /usr/bin/caddy
RUN chmod +x /usr/bin/caddy

LABEL org.opencontainers.image.authors="github.com/alexandzors"