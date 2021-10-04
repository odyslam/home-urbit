FROM caddy:2.4.5-builder AS builder
RUN xcaddy build \
          --with github.com/abiosoft/caddy-exec

FROM caddy:2.4.5-alpine
RUN apk --no-cache add curl
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY ./Caddyfile /etc/caddy/Caddyfile
ENTRYPOINT ["caddy", "run",  "--config", "/etc/caddy/Caddyfile"]
