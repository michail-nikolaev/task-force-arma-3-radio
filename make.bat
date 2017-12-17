@echo off
setlocal enabledelayedexpansion

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set armake=tools\armake_w64.exe) else (set armake=tools\armake_w32.exe)

for /d %%f in (addons\*) do (
    set folder=%%f
    set name=!folder:addons\=!
    echo   PBO  addons\tfar_!name!.pbo
    !armake! build -i include -w unquoted-string -w redefinition-wo-undef -f !folder! addons\tfar_!name!.pbo
)

pause
