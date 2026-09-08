# GBC Arcade — emulador Game Boy Color web

Web genérica que ejecuta ROMs de Game Boy Color en el navegador usando
[binjgb](https://github.com/binji/binjgb) (core C→WASM, el mismo que usa
GB Studio para sus exports web), vendorizado en `public/vendor/binjgb/`.

Historia de emuladores, para no repetir errores:
1. **EmulatorJS** (core gambatte): preciso, pero su capa de red/arranque
   falla en Chrome de iOS (#679) y iOS exige un gesto para arrancar.
2. **WasmBoy**: API JS limpia y autoarranque en iOS, pero su emulación GBC
   no soporta los trucos del juego (partición de pantalla vía LYC + ventana
   con WX=167): el fondo del circuito no se renderizaba. Además:
   `setJoypadState` espera claves EN MAYÚSCULAS y `play()` re-activa el
   joypad por defecto que pisa el estado manual.
3. **binjgb** (actual): preciso (renderiza bien los efectos LYC/ventana),
   arranca sin gesto en iOS (canvas 2D en iPhone, evita el leak de WebKit),
   pad táctil de GB Studio, save states y SRAM en localStorage.
   `emulator.js` es `docs/simple.js` de binjgb adaptado: arranque bajo
   demanda (`startBinjgb`) y claves de almacenamiento por juego. Recargar
   la página arranca de cero (sin reanudación automática, a propósito);
   F6/F9 guardan/cargan estado manualmente con teclado.

## Rutas

- `/` — menú con las ROMs disponibles
- `/<nombre>` — carga el emulador con `public/roms/<nombre>.gbc`
  (p. ej. `/madring` → `public/roms/madring.gbc`)

## Añadir una ROM

1. Copia el fichero a `public/roms/<nombre>.gbc` (el nombre de la ruta será el
   nombre del fichero sin extensión).
2. Añade el nombre a `public/roms/index.json` (el listado del menú).
3. Commit y push.

(En Railway el `Dockerfile` regenera `index.json` solo; en Vercel se usa el
fichero commiteado.)

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

Desplegado en Vercel (`vercel.json`: sirve `public/` con fallback SPA).
El `Dockerfile` + `Caddyfile` siguen sirviendo para Railway u otro host Docker.
