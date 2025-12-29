FROM --platform=$BUILDPLATFORM genesis AS genesis

FROM --platform=$BUILDPLATFORM ghcr.io/simonwep/ocular:v1.13.0 AS ocular

FROM caddy:alpine

WORKDIR /

ARG GENESIS_PORT
ENV GENESIS_PORT=${GENESIS_PORT}

COPY --from=genesis /app/genesis /usr/local/bin/genesis
COPY --from=ocular /home/static /usr/share/caddy

COPY Caddyfile /etc/caddy/Caddyfile
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:${GENESIS_PORT}/health || exit 1

ENTRYPOINT ["/entrypoint.sh"]
