#!/bin/bash
mkdir -p amd64
mkdir -p arm64
mkdir -p darwin
cd amd64
echo #################
echo BUILD AMD64/WIN64
echo #################
xcaddy build --with github.com/WeidiDeng/caddy-cloudflare-ip --with github.com/caddy-dns/cloudflare --with github.com/caddyserver/ntlm-transport --with github.com/caddyserver/replace-response --with github.com/greenpau/caddy-security --with github.com/caddyserver/transform-encoder --with github.com/caddyserver/nginx-adapter --with github.com/mholt/caddy-ratelimit
xcaddy build --output ./caddy.exe --with github.com/WeidiDeng/caddy-cloudflare-ip --with github.com/caddy-dns/cloudflare --with github.com/caddyserver/ntlm-transport --with github.com/caddyserver/replace-response --with github.com/greenpau/caddy-security --with github.com/caddyserver/transform-encoder --with github.com/caddyserver/nginx-adapter --with github.com/mholt/caddy-ratelimit
cd ../arm64
echo #################
echo BUILD ARM64
echo #################
export GOOS=linux
export GOARCH=arm64
xcaddy build --output ./caddy_arm64 --with github.com/WeidiDeng/caddy-cloudflare-ip --with github.com/caddy-dns/cloudflare --with github.com/caddyserver/ntlm-transport --with github.com/caddyserver/replace-response --with github.com/greenpau/caddy-security --with github.com/caddyserver/transform-encoder --with github.com/caddyserver/nginx-adapter --with github.com/mholt/caddy-ratelimit
cd ../darwin
echo #################
echo BUILD DARWIN
echo #################
export GOOS=darwin
export GOARCH=arm64
xcaddy build --output ./caddy_darwin --with github.com/WeidiDeng/caddy-cloudflare-ip --with github.com/caddy-dns/cloudflare --with github.com/caddyserver/ntlm-transport --with github.com/caddyserver/replace-response --with github.com/greenpau/caddy-security --with github.com/caddyserver/transform-encoder --with github.com/caddyserver/nginx-adapter --with github.com/mholt/caddy-ratelimit