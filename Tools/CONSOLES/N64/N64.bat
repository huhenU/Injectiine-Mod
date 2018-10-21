@echo off
title Injectiine [N64] - Mod
cls
cd ..
cd ..
cd ..
cd Files

echo ::::::::::::::::::::::::::
echo ::INJECTIINE [N64] - Mod::
echo ::::::::::::::::::::::::::

:: CHECK THAT FILES EXIST

IF NOT EXIST *.z64 GOTO:LastChanceOne

:Main
IF NOT EXIST bootTvTex.png GOTO:404ImagesNotFound
IF NOT EXIST iconTex.png GOTO:404ImagesNotFound

cd ..
cd Tools
cd CONSOLES
cd N64

:BASE
cls
echo Which base do you want to use?
echo Please note, that you should use a base that is close to the size of the game you are trying to inject,
echo otherwise it might not work correctly.
echo It's also recommended to use a base that is the same region as your game.
echo.
echo Excitebike 64 [USA] [11.58 MB]     (1)
echo Donkey Kong 64 [EUR] [52.72 MB]    (2)
echo Base supplied from Files [Custom]  (3)
echo.
echo Pick the number behind the base you want to use
echo.
set /p BASEDECIDE=[Your Choice:] 
IF %BASEDECIDE%==1 GOTO:EB
IF %BASEDECIDE%==2 GOTO:DK
IF %BASEDECIDE%==3 GOTO:BaseNotice
GOTO:BASE

:BaseNotice
cls
echo Please supply your base, including the code, content and meta
echo folders, in a directory called "Base" within the Files directory.
echo.
echo Press any key to continue.
pause>NUL
cd ..
cd ..
cd ..
cd Files
IF NOT EXIST Base GOTO:BASEFAIL
cd ..
cd Tools
cd CONSOLES
cd N64
GOTO:EnterCommon

:: ENTERING KEYS

:WrongKeyDK
cls
echo Title key is incorrect. Please try again.
SLEEP 2

:EnterKeyDK
cls

IF EXIST TitleKey.txt goto:EnterCommon
echo This step will not be required the next time you start Injectiine.
echo Enter the title key for Donkey Kong 64 (EUR):
set /p TITLEKEY=
echo %TITLEKEY:~0,32%>TitleKeyDK.txt
set /p TITLEKEY=<TitleKeyDK.txt
cls
IF "%TitleKEY:~0,4%"=="3229" GOTO:EnterCommon ELSE GOTO:WrongKeyDK

:WrongKeyEB
cls
echo Title key is incorrect. Please try again.
SLEEP 2

:EnterKeyEB
cls

IF EXIST TitleKey.txt goto:EnterCommon
echo This step will not be required the next time you start Injectiine.
echo Enter the title key for Excitebike 64 (USA):
set /p TITLEKEY=
echo %TITLEKEY:~0,32%>TitleKeyEB.txt
set /p TITLEKEY=<TitleKeyEB.txt
cls
IF "%TitleKEY:~0,4%"=="2ee3" GOTO:EnterCommon ELSE GOTO:WrongKeyEB

:DK
set BASEPDC=NAAP
set BASEID=0005000010199300
set BASEFOLDER="Donkey Kong 64 [NAAP01]"
set BASEINI=Undop0.599
IF EXIST TitleKeyDK.txt (set /p TITLEKEY=<TitleKeyDK.txt) ELSE (GOTO :EnterKeyDK)
GOTO:EnterCommon

:EB
set BASEPDC=NATE
set BASEID=00050000101e6500
set BASEINI=UNMXE1.683
set BASEFOLDER="Excitebike 64 [NATE01]"
IF EXIST TitleKeyEB.txt (set /p TITLEKEY=<TitleKeyEB.txt) ELSE (GOTO :EnterKeyEB)
GOTO:EnterCommon

:WrongCommon
cls
echo Wii U Common Key is incorrect. Please try again.
SLEEP 2

:EnterCommon
cls
IF EXIST NUSPacker/encryptKeyWith goto:EnterParameters
cd NUSPacker
echo This step will not be required the next time you start Injectiine.
set /p COMMON=Enter the Wii U Common Key: 
echo %COMMON:~0,32%>encryptKeyWith
set /p COMMON=<encryptKeyWith
cls
cd ..
echo http://ccs.cdn.wup.shop.nintendo.net/ccs/download>JNUSTool\config
echo %COMMON:~0,32%>>JNUSTool\config
echo https://tagaya.wup.shop.nintendo.net/tagaya/versionlist/EUR/EU/latest_version>>JNUSTool\config
echo https://tagaya-wup.cdn.nintendo.net/tagaya/versionlist/EUR/EU/list/%d.versionlist>>JNUSTool\config
IF "%COMMON:~0,4%"=="D7B0" GOTO:EnterParameters ELSE GOTO:WrongCommon

:: ENTER PARAMETERS

:EnterParameters
cls

set TITLEID=%random:~-1%%random:~-1%%random:~-1%%random:~-1%

:LineQuestion
echo How many lines does your game name use?
set /p LINEDECIDE=[1/2:] 
echo.
IF %LINEDECIDE%==1 GOTO:LINE1
IF %LINEDECIDE%==2 GOTO:LINE2
GOTO:LINEQUESTION

:LINE1
echo Enter the name of the game.
set /p GAMENAME=[Game Name:] 
echo.
GOTO:RestOfParameters

:LINE2
echo Enter a short version of the name of the game. This will be shown in the home-button-pause menu.
set /p GAMENAME=[Short Game Name:] 
echo.

echo Enter the game name's first line.
set /p GAMENAME1=[Game Name Line 1:] 
echo.

echo Enter the game name's second line.
set /p GAMENAME2=[Game Name Line 2:] 
echo.

:RestOfParameters
echo Enter a 4-digit product code.
set /p PRODUCTCODE=[0-Z:] 
echo.

echo Do you want to enter a title ID manually?
echo If you don't, one will be randomly assigned.
set /p TITLEDECIDE=[Y/N:] 
echo.
IF /i "%TITLEDECIDE%"=="y" (
echo Enter a 4-digit meta title ID. Must only be hex values. This can be anything.
set /p TITLEID=[0-F:] 
)
cls

echo Injectiine will now create an N64 injection.
echo If you don't accept this, you will need to reenter your parameters.
CHOICE /C YN
IF errorlevel 2 goto :EnterParameters
IF errorlevel 1 goto :DownloadingStuff

:: DOWNLOADING AND MOVING STUFF

:DownloadingStuff
cls
IF %BASEDECIDE%==3 GOTO:CopyBase
echo Testing Internet connection...
C:\windows\system32\PING.EXE google.com
if %errorlevel% GTR 0 goto:InternetSucks

IF EXIST WORKDIR echo Cleaning up working directory from last failed conversion...
IF EXIST WORKDIR rd /s /q WORKDIR
SLEEP 1
cd JNUSTool
echo Downloading base files...
rmdir /s /q %BASEFOLDER%
java -jar JNUSTool.jar %BASEID% %TITLEKEY% -file .*

:MovingStuff
echo Moving to work directory...
C:\Windows\System32\Robocopy.exe %BASEFOLDER% ..\WORKDIR\ /MIR
rmdir /s /q %BASEFOLDER%
cd ..
IF NOT EXIST WORKDIR GOTO:ROBOFAIL
cd WORKDIR
cd content
cd ..
cd ..
cls

:CustomIniName
cls
echo Do you want to define a custom INI/ROM name?
echo If you don't, the one from the base will be used.
set /p INIDECIDE=[Y/N:] 
IF /i "%INIDECIDE%"=="y" (GOTO:EnterCustomIni)
IF /i "%INIDECIDE%"=="n" (GOTO:InjectingROM)
GOTO:CustomIniName

:EnterCustomIni
cls
echo Enter a custom INI/ROM name.
echo FORMAT: UnxxxN.NNN
echo EXAMPLES: Unsme0.005, Undop0.599
set /p BASEINI=[INI/ROM Name:] 
GOTO:InjectingROM

:CopyBase
cls
echo Enter a custom INI/ROM name, or copy the one used by your base.
echo FORMAT: UnxxxN.NNN
echo EXAMPLES: Unsme0.005, Undop0.599
set /p BASEINI=[INI/ROM Name:] 
cls
echo Moving base to work directory...
C:\Windows\System32\Robocopy.exe ..\..\..\Files\Base WORKDIR\ /MIR
IF NOT EXIST WORKDIR GOTO:ROBOFAIL
cd WORKDIR
cd content
mkdir rom
mkdir config
mkdir Patch
cd ..
cd ..
cls

:: INJECTING ROM
:InjectingROM
echo Injecting ROM...
cd ..
cd ..
cd ..
cd Files
IF EXIST iconTex.png (copy iconTex.png ../Tools/png2tga)
IF NOT EXIST bootDrcTex.png (copy bootTvTex.png bootDrcTex.png)
IF EXIST bootTvTex.png (copy bootTvTex.png ../Tools/png2tga)
IF EXIST bootDrcTex.png (copy bootDrcTex.png ../Tools/png2tga)
IF EXIST bootLogoTex.png (copy bootLogoTex.png ../Tools/png2tga)

IF EXIST bootSound.wav echo bootSound detected. Do you want it to loop?
IF EXIST bootSound.wav set /p AUDIODECIDE=[Y/N:]
IF /i "%AUDIODECIDE%"=="n" set LOOP=-noLoop
IF EXIST bootSound.wav ..\Tools\sox\sox.exe .\bootSound.wav -b 16 bootEdited.wav channels 2 rate 48k trim 0 6
IF EXIST bootEdited.wav ..\Tools\wav2btsnd.jar -in bootEdited.wav -out bootSound.btsnd %LOOP%
IF EXIST bootSound.btsnd (copy bootSound.btsnd ../Tools/CONSOLES/NES/WORKDIR/meta/bootSound.btsnd)

IF EXIST *.z64 copy *.z64 ROM.z64
IF EXIST *.n64 java -jar ../Tools/CONSOLES/N64/N64Converter.jar -i *.n64 -o ROM.z64
IF EXIST *.v64 java -jar ../Tools/CONSOLES/N64/N64Converter.jar -i *.v64 -o ROM.z64
2>NUL del ROM.n64
2>NUL del ROM.v64
cd ..
move Files\ROM.z64 Tools\CONSOLES\N64\WORKDIR\content\rom\%BASEINI%
cd Tools
cd CONSOLES
cd N64
cd WORKDIR
cd content
mkdir Patch
mkdir config
cd config
SLEEP 1
cls

:COPY
echo Which config .ini file do you want to use?
echo.
echo Super Mario 64 [USA] (1)
echo Super Mario 64 [EUR] (2)
echo Donkey Kong 64 [USA] (3)
echo Donkey Kong 64 [EUR] (4)
echo Custom config .ini   (5)
echo Blank config .ini    (6)
echo Base config .ini     (7)
echo .INI file from Files (8)
echo.
echo Pick the number behind the config.ini you want to use
echo.
set /p BASEDECIDE=[Your Choice:] 
IF %BASEDECIDE%==1 GOTO:SM64UCOPY
IF %BASEDECIDE%==2 GOTO:SM64ECOPY
IF %BASEDECIDE%==3 GOTO:DKUCOPY
IF %BASEDECIDE%==4 GOTO:DKECOPY
IF %BASEDECIDE%==5 GOTO:CUSTOMINI
IF %BASEDECIDE%==6 GOTO:BLANKINI
IF %BASEDECIDE%==7 GOTO:BASEINI
IF %BASEDECIDE%==8 GOTO:ININotice
GOTO:COPY

:SM64UCOPY
cd ..
cd ..
cd ..
copy INIs\Unsme0.005.ini WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:SM64ECOPY
cd ..
cd ..
cd ..
copy INIs\UNSMP0.016.ini WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:DKUCOPY
cd ..
cd ..
cd ..
copy INIs\Undoe0.556.ini WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:DKECOPY
cd ..
cd ..
cd ..
copy INIs\Undop0.599.ini WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:BLANKINI
cd ..
cd ..
cd ..
copy INIs\Blank.ini WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:BASEINI
cd ..
cd ..
cd ..
copy INIs\%BASEINI%.ini WORKDIR\content\config\%BASEINI%.ini
cd WORKDIR
GOTO:NextStep

:ININotice
cls
echo Make sure your .INI file in the Files directory.
echo If there's none, a blank .INI file will be used.
echo.
echo Once you're done, press any key to continue.
pause>NUL
cls
cd ..
cd ..
cd ..
cd Files
IF NOT EXIST *.ini (copy ..\Tools\CONSOLES\N64\INIs\Blank.ini ..\Tools\CONSOLES\N64\WORKDIR\content\config\%BASEINI%.ini)
IF EXIST *.ini (copy *.ini ..\Tools\CONSOLES\N64\WORKDIR\content\config\%BASEINI%.ini)
cd ..
cd Tools
cd CONSOLES
cd N64
cls
GOTO:NextStep

:CUSTOMINI
echo [RomOption]>>%BASEINI%.ini

:TIMER
cls
echo Do you want to enable UseTimer?
echo This will limit the emulation speed.
set /p UseTimer=[Y/N:] 
echo.
IF /i "%UseTimer%"=="y" (
echo UseTimer = ^1>>%BASEINI%.ini
GOTO:VSYNC
)
IF /i "%UseTimer%"=="n" (
GOTO:VSYNC
)
GOTO:TIMER

:VSYNC
cls
echo Do you want to enable RetraceByVsync?
echo This will reduce lagging.
set /p Vsync=[Y/N:] 
echo.
IF /i "%Vsync%"=="y" (
echo RetraceByVsync = ^1>>%BASEINI%.ini
GOTO:RUMBLE
)
IF /i "%Vsync%"=="n" (
GOTO:RUMBLE
)
GOTO:VSYNC

:RUMBLE
cls
echo Do you want to enable Rumble?
echo This is recommended for games that use the Rumble Pak.
set /p Rumble=[Y/N:] 
echo.
IF /i "%Rumble%"=="y" (
echo Rumble = ^1>>%BASEINI%.ini
GOTO:MEMPAK
)
IF /i "%Rumble%"=="n" (
GOTO:MEMPAK
)
GOTO:RUMBLE

:MEMPAK
cls
echo Do you want to enable MemPak?
echo This is recommended for games that use the Memory Pak.
set /p MemPak=[Y/N:] 
echo.
IF /i "%MemPak%"=="y" (
echo MemPak = ^1>>%BASEINI%.ini
GOTO:PreParse
)
IF /i "%MemPak%"=="n" (
GOTO:PreParse
)
GOTO:MEMPAK

:PreParse
cls
echo Do you want to enable NeedPreParse?
echo This will fix some stutter and/or graphical glitches.
set /p PreParse=[Y/N:] 
echo.
IF /i "%PreParse%"=="y" (
@echo.>>%BASEINI%.ini
echo [Render]>>%BASEINI%.ini
echo NeedPreParse = ^1>>%BASEINI%.ini
GOTO:FinishCustom
)
IF /i "%PreParse%"=="n" (
GOTO:FinishCustom
)
GOTO:PreParse

:SM64
echo Do you want to enable Super Mario 64 BreakBlockInst?
echo This will make SM64 work with VC injection.
set /p SM64=[Y/N:] 
echo.
IF /i "%SM64%"=="y" (
@echo.>>%BASEINI%.ini
echo [BreakBlockInst]>>%BASEINI%.ini
echo Count = 1 >>%BASEINI%.ini
echo Address0 = 0x8027732C >>%BASEINI%.ini
echo Inst0 = 0x20C6FFFF >>%BASEINI%.ini
echo JmpPC0= 0x802772C0 >>%BASEINI%.ini
echo Type0 = 1 >>%BASEINI%.ini
GOTO:FinishCustom
)
IF /i "%SM64%"=="n" (
GOTO:FinishCustom
)
GOTO:SM64

:FinishCustom

cls

:: EDITING APP.XML AND META.XML

cd ..
cd ..


:NextStep
cls
echo Generating app.xml...
cd code
del /s app.xml >nul 2>&1
echo ^<?xml version="1.0" encoding="utf-8"?^>>app.xml
echo ^<app type="complex" access="777"^>>>app.xml
echo   ^<version type="unsignedInt" length="4"^>15^</version^>>>app.xml
echo   ^<os_version type="hexBinary" length="8"^>000500101000400A^</os_version^>>>app.xml
echo   ^<title_id type="hexBinary" length="8"^>000500001337%TITLEID%^</title_id^>>>app.xml
echo   ^<title_version type="hexBinary" length="2"^>0000^</title_version^>>>app.xml
echo   ^<sdk_version type="unsignedInt" length="4"^>21113^</sdk_version^>>>app.xml
echo   ^<app_type type="hexBinary" length="4"^>80000000^</app_type^>>>app.xml
echo   ^<group_id type="hexBinary" length="4"^>00001337^</group_id^>>>app.xml
echo   ^<os_mask type="hexBinary" length="32"^>0000000000000000000000000000000000000000000000000000000000000000^</os_mask^>>>app.xml
echo ^</app^>>>app.xml
SLEEP 1
cls

echo Generating meta.xml...
cd ..
cd meta
del /s meta.xml >nul 2>&1
echo ^<?xml version="1.0" encoding="utf-8"?^>>meta.xml
echo ^<menu type="complex" access="777"^>>>meta.xml
echo   ^<version type="unsignedInt" length="4"^>33^</version^>>>meta.xml
echo   ^<product_code type="string" length="32"^>WUP-N-%PRODUCTCODE%^</product_code^>>>meta.xml
echo   ^<content_platform type="string" length="32"^>WUP^</content_platform^>>>meta.xml
echo   ^<company_code type="string" length="8"^>0001^</company_code^>>>meta.xml
echo   ^<mastering_date type="string" length="32"^>^</mastering_date^>>>meta.xml
echo   ^<logo_type type="unsignedInt" length="4"^>0^</logo_type^>>>meta.xml
echo   ^<app_launch_type type="hexBinary" length="4"^>00000000^</app_launch_type^>>>meta.xml
echo   ^<invisible_flag type="hexBinary" length="4"^>00000000^</invisible_flag^>>>meta.xml
echo   ^<no_managed_flag type="hexBinary" length="4"^>00000000^</no_managed_flag^>>>meta.xml
echo   ^<no_event_log type="hexBinary" length="4"^>00000000^</no_event_log^>>>meta.xml
echo   ^<no_icon_database type="hexBinary" length="4"^>00000000^</no_icon_database^>>>meta.xml
echo   ^<launching_flag type="hexBinary" length="4"^>00000005^</launching_flag^>>>meta.xml
echo   ^<install_flag type="hexBinary" length="4"^>00000000^</install_flag^>>>meta.xml
echo   ^<closing_msg type="unsignedInt" length="4"^>0^</closing_msg^>>>meta.xml
echo   ^<title_version type="unsignedInt" length="4"^>0^</title_version^>>>meta.xml
echo   ^<title_id type="hexBinary" length="8"^>000500001337%TITLEID%^</title_id^>>>meta.xml
echo   ^<group_id type="hexBinary" length="4"^>00001337^</group_id^>>>meta.xml
echo   ^<boss_id type="hexBinary" length="8"^>0000000000000000^</boss_id^>>>meta.xml
echo   ^<os_version type="hexBinary" length="8"^>000500101000400A^</os_version^>>>meta.xml
echo   ^<app_size type="hexBinary" length="8"^>0000000000000000^</app_size^>>>meta.xml
echo   ^<common_save_size type="hexBinary" length="8"^>0000000000000000^</common_save_size^>>>meta.xml
echo   ^<account_save_size type="hexBinary" length="8"^>0000000002000000^</account_save_size^>>>meta.xml
echo   ^<common_boss_size type="hexBinary" length="8"^>0000000000000000^</common_boss_size^>>>meta.xml
echo   ^<account_boss_size type="hexBinary" length="8"^>0000000000000000^</account_boss_size^>>>meta.xml
echo   ^<save_no_rollback type="unsignedInt" length="4"^>0^</save_no_rollback^>>>meta.xml
echo   ^<join_game_id type="hexBinary" length="4"^>00000000^</join_game_id^>>>meta.xml
echo   ^<join_game_mode_mask type="hexBinary" length="8"^>0000000000000000^</join_game_mode_mask^>>>meta.xml
echo   ^<bg_daemon_enable type="unsignedInt" length="4"^>1^</bg_daemon_enable^>>>meta.xml
echo   ^<olv_accesskey type="unsignedInt" length="4"^>777542833^</olv_accesskey^>>>meta.xml
echo   ^<wood_tin type="unsignedInt" length="4"^>0^</wood_tin^>>>meta.xml
echo   ^<e_manual type="unsignedInt" length="4"^>1^</e_manual^>>>meta.xml
echo   ^<e_manual_version type="unsignedInt" length="4"^>0^</e_manual_version^>>>meta.xml
echo   ^<region type="hexBinary" length="4"^>00000004^</region^>>>meta.xml
echo   ^<pc_cero type="unsignedInt" length="4"^>128^</pc_cero^>>>meta.xml
echo   ^<pc_esrb type="unsignedInt" length="4"^>128^</pc_esrb^>>>meta.xml
echo   ^<pc_bbfc type="unsignedInt" length="4"^>192^</pc_bbfc^>>>meta.xml
echo   ^<pc_usk type="unsignedInt" length="4"^>6^</pc_usk^>>>meta.xml
echo   ^<pc_pegi_gen type="unsignedInt" length="4"^>7^</pc_pegi_gen^>>>meta.xml
echo   ^<pc_pegi_fin type="unsignedInt" length="4"^>192^</pc_pegi_fin^>>>meta.xml
echo   ^<pc_pegi_prt type="unsignedInt" length="4"^>6^</pc_pegi_prt^>>>meta.xml
echo   ^<pc_pegi_bbfc type="unsignedInt" length="4"^>7^</pc_pegi_bbfc^>>>meta.xml
echo   ^<pc_cob type="unsignedInt" length="4"^>0^</pc_cob^>>>meta.xml
echo   ^<pc_grb type="unsignedInt" length="4"^>128^</pc_grb^>>>meta.xml
echo   ^<pc_cgsrr type="unsignedInt" length="4"^>128^</pc_cgsrr^>>>meta.xml
echo   ^<pc_oflc type="unsignedInt" length="4"^>0^</pc_oflc^>>>meta.xml
echo   ^<pc_reserved0 type="unsignedInt" length="4"^>192^</pc_reserved0^>>>meta.xml
echo   ^<pc_reserved1 type="unsignedInt" length="4"^>192^</pc_reserved1^>>>meta.xml
echo   ^<pc_reserved2 type="unsignedInt" length="4"^>192^</pc_reserved2^>>>meta.xml
echo   ^<pc_reserved3 type="unsignedInt" length="4"^>192^</pc_reserved3^>>>meta.xml
echo   ^<ext_dev_nunchaku type="unsignedInt" length="4"^>0^</ext_dev_nunchaku^>>>meta.xml
echo   ^<ext_dev_classic type="unsignedInt" length="4"^>0^</ext_dev_classic^>>>meta.xml
echo   ^<ext_dev_urcc type="unsignedInt" length="4"^>0^</ext_dev_urcc^>>>meta.xml
echo   ^<ext_dev_board type="unsignedInt" length="4"^>0^</ext_dev_board^>>>meta.xml
echo   ^<ext_dev_usb_keyboard type="unsignedInt" length="4"^>0^</ext_dev_usb_keyboard^>>>meta.xml
echo   ^<ext_dev_etc type="unsignedInt" length="4"^>0^</ext_dev_etc^>>>meta.xml
echo   ^<ext_dev_etc_name type="string" length="512"^>^</ext_dev_etc_name^>>>meta.xml
echo   ^<eula_version type="unsignedInt" length="4"^>0^</eula_version^>>>meta.xml
echo   ^<drc_use type="unsignedInt" length="4"^>1^</drc_use^>>>meta.xml
echo   ^<network_use type="unsignedInt" length="4"^>0^</network_use^>>>meta.xml
echo   ^<online_account_use type="unsignedInt" length="4"^>0^</online_account_use^>>>meta.xml
echo   ^<direct_boot type="unsignedInt" length="4"^>0^</direct_boot^>>>meta.xml
echo   ^<reserved_flag0 type="hexBinary" length="4"^>00010001^</reserved_flag0^>>>meta.xml
echo   ^<reserved_flag1 type="hexBinary" length="4"^>00000000^</reserved_flag1^>>>meta.xml
echo   ^<reserved_flag2 type="hexBinary" length="4"^>00000000^</reserved_flag2^>>>meta.xml
echo   ^<reserved_flag3 type="hexBinary" length="4"^>00000000^</reserved_flag3^>>>meta.xml
echo   ^<reserved_flag4 type="hexBinary" length="4"^>00000000^</reserved_flag4^>>>meta.xml
echo   ^<reserved_flag5 type="hexBinary" length="4"^>00000000^</reserved_flag5^>>>meta.xml
echo   ^<reserved_flag6 type="hexBinary" length="4"^>00000003^</reserved_flag6^>>>meta.xml
echo   ^<reserved_flag7 type="hexBinary" length="4"^>00000001^</reserved_flag7^>>>meta.xml
IF %LINEDECIDE%==2 (
echo   ^<longname_ja type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_ja^>>>meta.xml
echo   ^<longname_en type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_en^>>>meta.xml
echo   ^<longname_fr type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_fr^>>>meta.xml
echo   ^<longname_de type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_de^>>>meta.xml
echo   ^<longname_it type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_it^>>>meta.xml
echo   ^<longname_es type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_es^>>>meta.xml
echo   ^<longname_zhs type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_zhs^>>>meta.xml
echo   ^<longname_ko type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_ko^>>>meta.xml
echo   ^<longname_nl type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_nl^>>>meta.xml
echo   ^<longname_pt type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_pt^>>>meta.xml
echo   ^<longname_ru type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_ru^>>>meta.xml
echo   ^<longname_zht type="string" length="512"^>%GAMENAME1%>>meta.xml
echo %GAMENAME2%^</longname_zht^>>>meta.xml
)
IF %LINEDECIDE%==1 (
echo   ^<longname_ja type="string" length="512"^>%GAMENAME%^</longname_ja^>>>meta.xml
echo   ^<longname_en type="string" length="512"^>%GAMENAME%^</longname_en^>>>meta.xml
echo   ^<longname_fr type="string" length="512"^>%GAMENAME%^</longname_fr^>>>meta.xml
echo   ^<longname_de type="string" length="512"^>%GAMENAME%^</longname_de^>>>meta.xml
echo   ^<longname_it type="string" length="512"^>%GAMENAME%^</longname_it^>>>meta.xml
echo   ^<longname_es type="string" length="512"^>%GAMENAME%^</longname_es^>>>meta.xml
echo   ^<longname_zhs type="string" length="512"^>%GAMENAME%^</longname_zhs^>>>meta.xml
echo   ^<longname_ko type="string" length="512"^>%GAMENAME%^</longname_ko^>>>meta.xml
echo   ^<longname_nl type="string" length="512"^>%GAMENAME%^</longname_nl^>>>meta.xml
echo   ^<longname_pt type="string" length="512"^>%GAMENAME%^</longname_pt^>>>meta.xml
echo   ^<longname_ru type="string" length="512"^>%GAMENAME%^</longname_ru^>>>meta.xml
echo   ^<longname_zht type="string" length="512"^>%GAMENAME%^</longname_zht^>>>meta.xml
)
echo   ^<shortname_ja type="string" length="256"^>%GAMENAME%^</shortname_ja^>>>meta.xml
echo   ^<shortname_en type="string" length="256"^>%GAMENAME%^</shortname_en^>>>meta.xml
echo   ^<shortname_fr type="string" length="256"^>%GAMENAME%^</shortname_fr^>>>meta.xml
echo   ^<shortname_de type="string" length="256"^>%GAMENAME%^</shortname_de^>>>meta.xml
echo   ^<shortname_it type="string" length="256"^>%GAMENAME%^</shortname_it^>>>meta.xml
echo   ^<shortname_es type="string" length="256"^>%GAMENAME%^</shortname_es^>>>meta.xml
echo   ^<shortname_zhs type="string" length="256"^>%GAMENAME%^</shortname_zhs^>>>meta.xml
echo   ^<shortname_ko type="string" length="256"^>%GAMENAME%^</shortname_ko^>>>meta.xml
echo   ^<shortname_nl type="string" length="256"^>%GAMENAME%^</shortname_nl^>>>meta.xml
echo   ^<shortname_pt type="string" length="256"^>%GAMENAME%^</shortname_pt^>>>meta.xml
echo   ^<shortname_ru type="string" length="256"^>%GAMENAME%^</shortname_ru^>>>meta.xml
echo   ^<shortname_zht type="string" length="256"^>%GAMENAME%^</shortname_zht^>>>meta.xml
echo   ^<publisher_ja type="string" length="256"^>Nintendo^</publisher_ja^>>>meta.xml
echo   ^<publisher_en type="string" length="256"^>Nintendo^</publisher_en^>>>meta.xml
echo   ^<publisher_fr type="string" length="256"^>Nintendo^</publisher_fr^>>>meta.xml
echo   ^<publisher_de type="string" length="256"^>Nintendo^</publisher_de^>>>meta.xml
echo   ^<publisher_it type="string" length="256"^>Nintendo^</publisher_it^>>>meta.xml
echo   ^<publisher_es type="string" length="256"^>Nintendo^</publisher_es^>>>meta.xml
echo   ^<publisher_zhs type="string" length="256"^>Nintendo^</publisher_zhs^>>>meta.xml
echo   ^<publisher_ko type="string" length="256"^>Nintendo^</publisher_ko^>>>meta.xml
echo   ^<publisher_nl type="string" length="256"^>Nintendo^</publisher_nl^>>>meta.xml
echo   ^<publisher_pt type="string" length="256"^>Nintendo^</publisher_pt^>>>meta.xml
echo   ^<publisher_ru type="string" length="256"^>Nintendo^</publisher_ru^>>>meta.xml
echo   ^<publisher_zht type="string" length="256"^>Nintendo^</publisher_zht^>>>meta.xml
echo   ^<add_on_unique_id0 type="hexBinary" length="4"^>00000000^</add_on_unique_id0^>>>meta.xml
echo   ^<add_on_unique_id1 type="hexBinary" length="4"^>00000000^</add_on_unique_id1^>>>meta.xml
echo   ^<add_on_unique_id2 type="hexBinary" length="4"^>00000000^</add_on_unique_id2^>>>meta.xml
echo   ^<add_on_unique_id3 type="hexBinary" length="4"^>00000000^</add_on_unique_id3^>>>meta.xml
echo   ^<add_on_unique_id4 type="hexBinary" length="4"^>00000000^</add_on_unique_id4^>>>meta.xml
echo   ^<add_on_unique_id5 type="hexBinary" length="4"^>00000000^</add_on_unique_id5^>>>meta.xml
echo   ^<add_on_unique_id6 type="hexBinary" length="4"^>00000000^</add_on_unique_id6^>>>meta.xml
echo   ^<add_on_unique_id7 type="hexBinary" length="4"^>00000000^</add_on_unique_id7^>>>meta.xml
echo   ^<add_on_unique_id8 type="hexBinary" length="4"^>00000000^</add_on_unique_id8^>>>meta.xml
echo   ^<add_on_unique_id9 type="hexBinary" length="4"^>00000000^</add_on_unique_id9^>>>meta.xml
echo   ^<add_on_unique_id10 type="hexBinary" length="4"^>00000000^</add_on_unique_id10^>>>meta.xml
echo   ^<add_on_unique_id11 type="hexBinary" length="4"^>00000000^</add_on_unique_id11^>>>meta.xml
echo   ^<add_on_unique_id12 type="hexBinary" length="4"^>00000000^</add_on_unique_id12^>>>meta.xml
echo   ^<add_on_unique_id13 type="hexBinary" length="4"^>00000000^</add_on_unique_id13^>>>meta.xml
echo   ^<add_on_unique_id14 type="hexBinary" length="4"^>00000000^</add_on_unique_id14^>>>meta.xml
echo   ^<add_on_unique_id15 type="hexBinary" length="4"^>00000000^</add_on_unique_id15^>>>meta.xml
echo   ^<add_on_unique_id16 type="hexBinary" length="4"^>00000000^</add_on_unique_id16^>>>meta.xml
echo   ^<add_on_unique_id17 type="hexBinary" length="4"^>00000000^</add_on_unique_id17^>>>meta.xml
echo   ^<add_on_unique_id18 type="hexBinary" length="4"^>00000000^</add_on_unique_id18^>>>meta.xml
echo   ^<add_on_unique_id19 type="hexBinary" length="4"^>00000000^</add_on_unique_id19^>>>meta.xml
echo   ^<add_on_unique_id20 type="hexBinary" length="4"^>00000000^</add_on_unique_id20^>>>meta.xml
echo   ^<add_on_unique_id21 type="hexBinary" length="4"^>00000000^</add_on_unique_id21^>>>meta.xml
echo   ^<add_on_unique_id22 type="hexBinary" length="4"^>00000000^</add_on_unique_id22^>>>meta.xml
echo   ^<add_on_unique_id23 type="hexBinary" length="4"^>00000000^</add_on_unique_id23^>>>meta.xml
echo   ^<add_on_unique_id24 type="hexBinary" length="4"^>00000000^</add_on_unique_id24^>>>meta.xml
echo   ^<add_on_unique_id25 type="hexBinary" length="4"^>00000000^</add_on_unique_id25^>>>meta.xml
echo   ^<add_on_unique_id26 type="hexBinary" length="4"^>00000000^</add_on_unique_id26^>>>meta.xml
echo   ^<add_on_unique_id27 type="hexBinary" length="4"^>00000000^</add_on_unique_id27^>>>meta.xml
echo   ^<add_on_unique_id28 type="hexBinary" length="4"^>00000000^</add_on_unique_id28^>>>meta.xml
echo   ^<add_on_unique_id29 type="hexBinary" length="4"^>00000000^</add_on_unique_id29^>>>meta.xml
echo   ^<add_on_unique_id30 type="hexBinary" length="4"^>00000000^</add_on_unique_id30^>>>meta.xml
echo   ^<add_on_unique_id31 type="hexBinary" length="4"^>00000000^</add_on_unique_id31^>>>meta.xml
echo ^</menu^>>>meta.xml
SLEEP 1
cls

:: INJECTING IMAGES
:InjectingImages
cd ..
cd ..
cd ..
cd ..
cd png2tga
echo Converting images to TGA...
png2tgacmd.exe -i iconTex.png --width=128 --height=128 --tga-bpp=32 --tga-compression=none
png2tgacmd.exe -i bootTvTex.png --width=1280 --height=720 --tga-bpp=24 --tga-compression=none
png2tgacmd.exe -i bootDrcTex.png --width=854 --height=480 --tga-bpp=24 --tga-compression=none
IF EXIST bootLogoTex.png (png2tgacmd.exe -i bootLogoTex.png --width=170 --height=42 --tga-bpp=32 --tga-compression=none)
title Injectiine [N64] - Mod
MetaVerifiy.py
cls
echo Moving images to meta folder...
move iconTex.tga ..\CONSOLES\N64\WORKDIR\meta
move bootTvTex.tga ..\CONSOLES\N64\WORKDIR\meta
move bootDrcTex.tga ..\CONSOLES\N64\WORKDIR\meta
2>NUL copy bootLogoTex.tga ..\CONSOLES\N64\WORKDIR\meta
cls

:PackPrompt
cls
echo Do you want to pack the game using NUSPacker? This is recommended if you want to install it to your wiiu.
echo If you don't wish to, the game will be created in Loadiine format.
set /p PACKDECIDE=[Y/N:] 
IF /i "%PACKDECIDE%"=="n" (GOTO:LoadiinePack)
IF /i "%PACKDECIDE%"=="y" (GOTO:PackGame)
GOTO:PackPrompt

:LoadiinePack
cls
cd ../CONSOLES/N64
cd ..
move N64\WORKDIR ..\..\Output\"[N64] %GAMENAME% [%PRODUCTCODE%]"
GOTO:FinalCheckLoadiine

:: PACK GAME
:PackGame
echo Packing game...
cd ../CONSOLES/N64
cd ..
move N64\WORKDIR N64\NUSPacker\WORKDIR
cd N64
cd NUSPacker
java -jar NUSPacker.jar -in WORKDIR -out "[N64] %GAMENAME% (000500001337%TITLEID%)"
rd /s /q tmp
rd /s /q WORKDIR
rd /s /q output
move "[N64] %GAMENAME% (000500001337%TITLEID%)" ..\..\..\..\Output

:: Final check if game exists
:FinalCheck
cd ..\..\..\..\Output
IF NOT EXIST "[N64] %GAMENAME% (000500001337%TITLEID%)" GOTO:GameError
GOTO:GameComplete

:FinalCheckLoadiine
cd ..\..\Output
IF NOT EXIST "[N64] %GAMENAME% [%PRODUCTCODE%]" GOTO:LoadiineError
GOTO:GameComplete

:GameComplete
cls
echo ::::::::::::::::::::::
echo ::INJECTION COMPLETE::
echo ::::::::::::::::::::::
echo.
echo A folder has been created named
IF /i "%PACKDECIDE%"=="y" echo "[N64] %GAMENAME% (000500001337%TITLEID%)"
IF /i "%PACKDECIDE%"=="n" echo "[N64] %GAMENAME% [%PRODUCTCODE%]"
echo in the Output directory with the injected game. You can install this using
echo WUP Installer GX2.
echo.
echo Do you want to delete the files in the Files directory? This will delete your Base, Rom, and Images!
echo.
echo 1 = Yes
echo 2 = No
set /p DELDECIDE=[Your Choice:]
IF %DELDECIDE%==1 GOTO:DELF
IF %DELDECIDE%==2 GOTO:NDELF
pause>NUL
exit

:: ERRORS

:LastChanceOne
IF NOT EXIST *.n64 GOTO:LastChanceTwo
GOTO :Main

:LastChanceTwo
IF NOT EXIST *.v64 GOTO:404ROMnotFound
GOTO :Main

:404ROMnotFound
cls
cd ..
cd Tools
cd CONSOLES
cd N64
echo :::::::::
echo ::ERROR::
echo :::::::::
echo.
echo N64 ROM not found.
echo.
echo Aborting in five seconds.
SLEEP 5
exit

:404ImagesNotFound
cls
echo :::::::::
echo ::ERROR::
echo :::::::::
echo.
echo Images not found.
echo.
echo Make sure you have the following images in the Files directory:
echo bootTvTex.png (1280 x 720)
echo iconTex.png (128 x 128)
echo.
echo Aborting in five seconds.
SLEEP 5
exit

:LoadiineError
cls
echo :::::::::
echo ::ERROR::
echo :::::::::
echo.
echo Failed to create a Loadiine package.
echo.
echo Aborting in five seconds.
SLEEP 5
exit

:GameError
cls
echo :::::::::
echo ::ERROR::
echo :::::::::
echo.
echo Failed to create a WUP package.
echo.
echo Aborting in five seconds.
SLEEP 5
exit

:ROBOFAIL
cls
echo :::::::::
echo ::ERROR::
echo :::::::::
echo.
echo Robocopy failed to create a working directory with the base files.
echo.
echo Aborting in five seconds.
SLEEP 5
exit

:BASEFAIL
cls
echo :::::::::
echo ::ERROR::
echo :::::::::
echo.
echo Base to supply not found.
echo.
echo Aborting in five seconds.
SLEEP 5
exit

:InternetSucks
cls
echo :::::::::
echo ::ERROR::
echo :::::::::
echo.
echo Internet connection test failed.
echo.
echo Aborting in five seconds.
SLEEP 5
exit

:DELF
cd ..\
del /s /f /q Files\* 
clear
echo Closing in five seconds
SLEEP 5
exit

:NDELF
cd ..\
Closing in five seconds
SLEEP 5
exit