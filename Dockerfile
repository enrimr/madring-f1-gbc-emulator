FROM caddy:2-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY public /srv
# Genera /roms/index.json con los nombres de las ROMs disponibles
RUN cd /srv/roms && { \
      printf '['; sep=''; \
      for f in *.gbc; do [ -e "$f" ] || continue; printf '%s"%s"' "$sep" "${f%.gbc}"; sep=','; done; \
      printf ']'; \
    } > index.json && cat index.json
ENV PORT=8080
CMD ["sh", "-c", "caddy run --config /etc/caddy/Caddyfile --adapter caddyfile"]
