@echo off

P:
echo %CD%
for %%F in (%CD%\*.tga) do (
   pal2pace.exe "%%~nF.tga" "%%~nF.paa"
)
pause