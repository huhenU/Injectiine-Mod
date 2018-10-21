@echo off
title Injectiine - Mod 0.1
:Menu
cls
echo :::::::::::::::::::::::::::::
echo ::Welcome to Injectiine Mod::
echo :::::::::::::::::::::::::::::
echo.
echo Please select the console of the game you want to inject.
echo.
echo Nintendo Entertainment System        (1)
echo Super Nintendo Entertainment System  (2)
echo Nintendo 64                          (3)
echo Gameboy Advance                      (4)
echo Nintendo DS                          (5)
echo.
echo Pick the number behind your console
echo.
set /p CHOICE=[Your Choice:] 
if %CHOICE%==1 GOTO:NES
if %CHOICE%==2 GOTO:SNES
if %CHOICE%==3 GOTO:N64
if %CHOICE%==4 GOTO:GBA
if %CHOICE%==5 GOTO:NDS
GOTO:Menu

:NES
cd CONSOLES
cd NES
call NES.bat
exit

:SNES
cd CONSOLES
cd SNES
call SNES.bat
exit

:N64
cd CONSOLES
cd N64
call N64.bat
exit

:GBA
cd CONSOLES
cd GBA
call GBA.bat
exit

:NDS
cd CONSOLES
cd NDS
call NDS.bat
exit