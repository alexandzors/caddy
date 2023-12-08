# Caddy
[![Caddy](https://github.com/alexandzors/caddy/actions/workflows/caddy.yml/badge.svg?branch=main&event=workflow_run)](https://github.com/alexandzors/caddy/actions/workflows/caddy.yml)

> Caddy is a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go.

Docs: https://caddyserver.com/docs/

Website: https://caddyserver.com/

Community: https://caddy.community/

GitHub: https://github.com/caddyserver/caddy

Parent Image: https://hub.docker.com/_/caddy

Build Repo: https://github.com/alexandzors/caddy

Binary Releases: https://github.com/alexandzors/caddy/releases

# Tags:

- `:latest` -- most recent Caddy stable version.
- `:dev` -- used for testing stuff. DO NOT USE :)

# Added Modules:
This image is built with the default [modules](https://caddyserver.com/docs/modules/) + the following:

> #### ***Note**: sjtug/caddy2-filter has been replaced with caddyserver/replace-response

- [dns.providers.cloudflare](https://caddyserver.com/docs/modules/dns.providers.cloudflare)
- [WeidiDeng/caddy-cloudflare-ip](https://github.com/WeidiDeng/caddy-cloudflare-ip)
- [caddyserver/ntlm-transport](https://github.com/caddyserver/ntlm-transport)
- [caddyserver/replace-response](https://github.com/caddyserver/replace-response)
- [greenpau/caddy-security](https://github.com/greenpau/caddy-security)
- [caddyserver/transform-encoder](https://github.com/caddyserver/transform-encoder)
- [caddyserver/nginx-adapter](https://github.com/caddyserver/nginx-adapter)
- [github.com/RussellLuo/caddy-ext/ratelimit](https://github.com/RussellLuo/caddy-ext/ratelimit)

# Deploying with Docker Compose

*This example includes an external docker network for other containers to attach to. This makes it so you can deploy this, attach other containers to the network, and then call said containers via their dns name rather then container ip. To create the network: `docker network create caddy-dockerinternal-net` then in each service you want exposed by caddy, add both `networks:` blocks to their compose files. Caddy will use both the bridge network using ports 80/443 and talk to other containers over the `caddy-dockerinternal-net` network.* 

```yml
# For use with <alexandzors/caddy>
# Created by github.com/alexandzors 08-18-2023
version: '3'
services:
  caddy:
    restart: always
    logging:
      driver: "json-file"
      options:
        max-size: "500k"
        max-file: "1"
    networks:
      - caddy
    image: alexandzors/caddy
    env_file: .env
    ports:
      - 80:80
      - 443:443
    volumes:
      - ${PWD}/Caddyfile:/etc/caddy/Caddyfile:ro # Caddyfile for configuration
      - ${PWD}/config:/etc/caddy/config # Optional if you want outside config files not polluting caddy parent dir
      - ${PWD}/.data:/data # Location of on host cert storage.
      - ${PWD}/logs:/logs # Optional if you want to set up domain logging files.

networks:
  caddy:
    name: caddy-dockerinternal-net
    external: true
```


## .env file:
```shell
CLOUDFLARETOKEN=YOUR_CLOUDFLARE_TOKEN_HERE
```

A more in depth docs breakdown can be found in the [official Caddy docker image repository](https://hub.docker.com/_/caddy).

# Using the Cloudflare DNS module

https://github.com/caddy-dns/cloudflare#config-examples
> #### ***Note**: You will need to create a scoped API token for Caddy. DO NOT USE GLOBAL API KEYS. See [here](https://github.com/libdns/cloudflare).

## Json API
```
{
	"module": "acme",
	"challenges": {
		"dns": {
			"provider": {
				"name": "cloudflare",
				"api_token": "{env.CLOUDFLARETOKEN}"
			}
		}
	}
}
```

## Caddyfile
Make it a reusable block:

```
(tls) {
    tls {
        dns cloudflare {env.CLOUDFLARETOKEN}
    }
}
```
Call said block:

```
domain.tld {
  import tls
  reverse_proxy 127.0.0.1:81
}
```

# Using weidideng/caddy-cloudflare-ip
Pulls Cloudflare endpoint IPs for use in `trusted_proxies` global config

## JSON API

```json
{
  "apps": {
    "http": {
      "servers": {
        "srv0": {
          "listen": [
            ":443"
          ],
          "trusted_proxies": {
            "interval": 43200000000000,
            "source": "cloudflare",
            "timeout": 15000000000
          }
        }
      }
    }
  }
}
```


## Caddyfile

```
# Global Config
{
  servers {
    trusted_proxies cloudflare {
      interval 12h
      timeoute 15s
    }
  }
}

mysite.com {
  respond * "Hello there"
}
```

# Using NTLM-Transport

`http_ntlm` acts the same as `http` except HTTP its always version 1.1 and Keep-Alive is disabled.

## JSON API
```json
{
  "match": [
    {
      "host": ["wac.domain.tld"]
    }
  ],
  "handle": [
    {
      "handler": "subroute",
      "routes": [
        {
          "handle": [
            {
              "encodings": {
                "gzip": {}
              },
              "handler": "encode"
            },
            {
              "handler": "reverse_proxy",
              "transport": {
                "protocol": "http_ntlm",
                "tls": {
                  "insecure_skip_verify": true
                }
              },
              "upstreams": {
                {
                  "dial": "192.168.1.5:443"
                }
              }
            }
          ]
        }
      ]
    }
  ]
}
```

## Caddyfile
```
wac.domain.tld {
  import tls
  encode gzip
  reverse_proxy {
    transport http_ntlm {
      tls_insecure_skip_verify
    }
    to 192.168.1.5:443
  }
}
```

# Other Modules

- Replace-Response usage: [https://github.com/caddyserver/replace-response](https://github.com/caddyserver/replace-response)
- Caddy-Security usage: [https://authp.github.io/docs/intro](https://authp.github.io/docs/intro)
- Transform Encoder usage: [https://github.com/caddyserver/transform-encoder](https://github.com/caddyserver/transform-encoder)
- Nginx Adapter usage: [https://github.com/caddyserver/nginx-adapter](https://github.com/caddyserver/nginx-adapter#use)
- Ratelimit usage: [https://github.com/RussellLuo/caddy-ext/tree/master/ratelimit](https://github.com/RussellLuo/caddy-ext/tree/master/ratelimit)
