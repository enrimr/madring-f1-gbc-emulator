# Madring GP — emulador GBC web

Web estática que ejecuta la ROM `madringgp.gbc` (Game Boy Color) en el navegador
usando [EmulatorJS](https://emulatorjs.org) (core Gambatte, cargado desde su CDN).

## Estructura

- `public/index.html` — página del emulador
- `public/rom/madringgp.gbc` — la ROM (origen: `f1-madring-gbc/bin/madringgp.gbc`)
- `Dockerfile` — sirve `public/` con Caddy (respeta `$PORT`, listo para Railway)

## Desarrollo local

```sh
python3 -m http.server 8080 -d public
# http://localhost:8080
```

## Despliegue

Desplegado en Railway con dominio personalizado `madring.enri.me`.

Para actualizar la ROM: recompilar en `f1-madring-gbc`, copiar el `.gbc` a
`public/rom/` y volver a desplegar.
