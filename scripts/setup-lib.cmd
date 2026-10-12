@echo off
rem One-time LSP setup: points .lib\ at smods, the extracted vanilla game code,
rem and love2d type defs (see .luarc.json workspace.library).
setlocal

set "MODS=%AppData%\Balatro\Mods"
rem Override with: set BALATRO_EXE=D:\path\to\Balatro.exe before running.
if not defined BALATRO_EXE set "BALATRO_EXE=D:\SteamLibrary\steamapps\common\Balatro\Balatro.exe"

if not exist ".lib" mkdir ".lib"

rem 1. SMODS: junction to the game-side install under %%AppData%%\Balatro\Mods
if exist ".lib\smods" goto :smods_ok
if not exist "%MODS%\smods" goto :smods_warn
mklink /J ".lib\smods" "%MODS%\smods"
if errorlevel 1 (
    echo ERROR: mklink smods failed.
    exit /b 1
)
goto :smods_done
:smods_ok
echo OK: .lib\smods already linked
goto :smods_done
:smods_warn
echo WARN: %MODS%\smods not found. Install SMODS first and re-run.
:smods_done

rem 2. Balatro: extract the vanilla game code (Balatro.exe is a LOVE app archive).
rem    .lib\balatro is a real folder, NOT a junction; re-extract after game updates.
if exist ".lib\balatro\game.lua" goto :balatro_ok
rem 7-Zip: PATH first, then the default install location (the Windows installer
rem does NOT add 7-Zip to PATH).
set "SEVENZ="
where 7z >nul 2>nul
if not errorlevel 1 set "SEVENZ=7z"
if not defined SEVENZ if exist "C:\Program Files\7-Zip\7z.exe" set "SEVENZ=C:\Program Files\7-Zip\7z.exe"
if not defined SEVENZ goto :balatro_no7z
if not exist "%BALATRO_EXE%" goto :balatro_noexe
echo Extracting with %SEVENZ%: %BALATRO_EXE% -^> .lib\balatro (read-only reference)
"%SEVENZ%" x "%BALATRO_EXE%" -o".lib\balatro" -y >nul
if errorlevel 1 (
    echo ERROR: extraction failed.
    exit /b 1
)
goto :balatro_done
:balatro_ok
echo OK: .lib\balatro already extracted
goto :balatro_done
:balatro_no7z
echo WARN: 7-Zip not found (checked PATH and C:\Program Files\7-Zip).
echo        Install it (https://www.7-zip.org) and re-run, or extract manually:
echo        7z x "%BALATRO_EXE%" -o.lib\balatro
goto :balatro_done
:balatro_noexe
echo WARN: %BALATRO_EXE% not found. Set BALATRO_EXE to your Balatro.exe and re-run.
goto :balatro_done
:balatro_done

rem 3. love2d: type annotations for the love.* API (LOVE C API is not in the game archive)
if exist ".lib\love2d" goto :love2d_ok
git clone --depth 1 https://github.com/LuaCATS/love2d ".lib\love2d"
if errorlevel 1 (
    echo ERROR: git clone love2d failed.
    exit /b 1
)
goto :love2d_done
:love2d_ok
echo OK: .lib\love2d already cloned
:love2d_done

echo.
echo Done. Restart the Lua language server (Ctrl+Shift+P -^> 'Lua: Restart Language Server').
endlocal

