@echo off
cd /d "%~dp0"
if not "x%TRUSTEDINSTALLER%"=="x1" (
    set TRUSTEDINSTALLER=1
    "%~dp0data\tools\NSudo.exe" -U:T -P:E -Wait -UseCurrentConsole cmd /c "%~0"
    ::pause
     exit
    goto :EOF
)





echo .正在初始化....
echo 检测注册表配置单元残留
for %%a in (install-soft os-drv os-soft os-sys pe-drv pe-sys pe-soft pe-def) do (
set item=%%a
call :checkitem %item%
)
goto startplay

:checkitem
reg query hklm |find "%item%"
if "%errorlevel%" == "0" echo 存在残留键值%item%, 卸载.&&reg unload hklm\%item%>nul
if "%errorlevel%" == "1" echo 未检出残留
exit /b



:startplay
start "" %~dp0bin\winxshell.exe -console -log -script %~dp0CrazeNewBin.lua
echo 按任意键开始，
pause
:init

echo .查找光盘分区
set cddir=
for %%a in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (
if exist %%a:\sources\install.wim set wimdir=%%a:\sources\install.wim
if exist %%a:\sources\install.esd set wimdir=%%a:\sources\install.esd
)
if not "%wimdir%" == "" echo 自动调整用完整注册表%wimdir%&&call :load_install

if not exist %~dp0software echo 当前目录没有找到你的注册表(software)&&pause&&exit
echo 开始生成3M精简版software…………
:nextplay


rem 挂载空注册表单元
reg load hklm\pe-soft %~dp0software_out
rem 挂载完整注册表配置单元
reg load hklm\os-soft %~dp0software
rem 原生壳支持
::call :explorer_support

pause