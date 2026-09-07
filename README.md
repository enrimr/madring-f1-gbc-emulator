# GBC Arcade — emulador Game Boy Color web

Web genérica que ejecuta ROMs de Game Boy Color en el navegador usando
[EmulatorJS](https://emulatorjs.org) (core Gambatte, cargado desde su CDN).

## Rutas

- `/` — menú con las ROMs disponibles
- `/<nombre>` — carga el emulador con `public/roms/<nombre>.gbc`
  (p. ej. `/madring` → `public/roms/madring.gbc`)

## Añadir una ROM

1. Copia el fichero a `public/roms/<nombre>.gbc` (el nombre de la ruta será el
   nombre del fichero sin extensión).
2. Despliega: `railway up`

El `Dockerfile` regenera `roms/index.json` (el listado del menú) en cada build.

## Estructura

- `public/index.html` — página única: menú + emulador según la ruta
- `public/roms/*.gbc` — las ROMs
- `Caddyfile` — sirve `public/` con fallback SPA (`/loquesea` → `index.html`)
- `Dockerfile` — imagen Caddy, respeta `$PORT`, lista para Railway

## Desarrollo local

```sh
# genera el índice a mano la primera vez:
cd public/roms && printf '["madring"]' > index.json && cd ../..
python3 -m http.server 8080 -d public   # ojo: sin fallback SPA, usa / y el menú
```

## Despliegue

Desplegado en Railway. Dominios: `madring.enri.me` y `emulator.enri.me`
(CNAME → `rn9ctx4d.up.railway.app`).
