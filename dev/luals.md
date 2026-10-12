# LuaLS

Theres a config for [luaLS](https://luals.github.io/) in `.luarc.json` by default. It indexes:

- `.lib/smods` — symlink to the SMODS install
- `.lib/balatro` — extracted vanilla game code (read-only reference)
- `.lib/love2d` — clone of https://github.com/LuaCATS/love2d (love.* API annotations)
- `types/globals.lua` — shim for runtime globals no source file defines

To set up `.lib/` run `scripts/setup-lib.cmd` (or the VS Code task **setup: link LSP libraries
(.lib)**). Set `BALATRO_MODS` / `BALATRO_EXE` env vars if your installs live elsewhere.
It links `%AppData%\Balatro\Mods\smods` in, extracts `Balatro.exe` (a LÖVE app archive) into
`.lib/balatro` with 7zip, and shallow-clones `LuaCATS/love2d`. It's idempotent — re-run after
game updates to re-extract the game code.
