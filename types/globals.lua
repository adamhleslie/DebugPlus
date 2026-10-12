-- Shim for runtime globals no indexed source file defines.
-- LuaLS registers globals via top-level assignment.
-- luacheck: globals GameCfg window inject

---@type table
GameCfg = GameCfg

--- LÖVE window wrapper injected by Lovely
---@type table
window = window

--- Lovely patch injection helper
---@type fun(target: string, path: string, patch: string?, silent: boolean?): boolean
inject = inject
