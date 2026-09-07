FROM caddy:2-alpine
COPY public /srv
ENV PORT=8080
CMD ["sh", "-c", "caddy file-server --root /srv --listen :${PORT}"]
