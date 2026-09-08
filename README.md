# GBC Arcade — emulador Game Boy Color web

Web genérica que ejecuta ROMs de Game Boy Color en el navegador usando
[WasmBoy](https://github.com/torch2424/wasmBoy) (emulador GB/GBC en
WebAssembly, cargado desde unpkg). Antes usaba EmulatorJS, pero su capa de
red/arranque fallaba en Chrome de iOS; con WasmBoy controlamos nosotros la
descarga de la ROM, el canvas, los controles táctiles y el autoguardado
(reanudación automática si WebKit mata la pestaña).

Gotchas de WasmBoy aprendidos a base de depurar:
- `setJoypadState` espera claves EN MAYÚSCULAS (`UP`, `A`, `START`...); el
  wiki las documenta en minúsculas y en minúsculas no funciona.
- `play()`/`loadROM()` re-activan el joypad por defecto (responsive-gamepad),
  que sobrescribe `setJoypadState` cada frame: hay que llamar a
  `disableDefaultJoypad()` DESPUÉS de cada `play()`.

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
