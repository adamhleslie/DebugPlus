@echo off
rem Junctions this repo's mod folder (the repo root, smods.json lives here) into
rem %AppData%\Balatro\Mods (one-time). Edit-in-place dev loop: the game loads
rem this folder directly, so save + restart (M / Alt+F5) instead of rebuilding.
setlocal

set "MODS=%AppData%\Balatro\Mods"
set "LINK=%MODS%\DebugPlus"
set "TARGET=%~dp0.."

if not exist "%MODS%" mkdir "%MODS%"

if exist "%LINK%" (
    echo ERROR: "%LINK%" already exists. Remove it with: rmdir "%LINK%"
    exit /b 1
)

mklink /J "%LINK%" "%TARGET%"

if errorlevel 1 (
    echo ERROR: mklink failed.
    exit /b 1
)

echo OK: junction created.
