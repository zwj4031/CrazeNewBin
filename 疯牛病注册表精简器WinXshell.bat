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
echo 按任意键开始，
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



echo 复制必要的software注册表到空注册表
for /f "tokens=*" %%e in (%~dp0data\reg\pe-soft-winxshell-mini.txt) do (
echo %%e
reg copy "hklm\os-soft\%%e" "hklm\pe-soft\%%e" /S /F
if errorlevel 1 reg copy "hklm\install-soft\%%e" "hklm\pe-soft\%%e" /S /F
)

echo 复制必要的software注册表项到空注册表
for /f "tokens=*" %%e in (%~dp0data\reg\pe+soft.txt) do (
echo %%e
reg copy "hklm\os-soft\%%e" "hklm\pe-soft\%%e" /F
if errorlevel 1 reg copy "hklm\install-soft\%%e" "hklm\pe-soft\%%e" /F
)

rem 注册表自带项补丁
echo 修补注册表
for /f %%r in ('dir /b %~dp0data\fix\*.reg') do (
echo 发现注册表补丁 %~dp0data\fix\%%r
reg import %~dp0data\fix\%%r
)


echo 替换c/d为x，删除Interactive User
"%~dp0data\tools\regfind" -p HKEY_LOCAL_MACHINE\pe-soft -y C:\ -y -r X:\
"%~dp0data\tools\regfind" -p HKEY_LOCAL_MACHINE\pe-soft -y D:\ -y -r X:\
"%~dp0data\tools\regfind" -p HKEY_LOCAL_MACHINE\pe-soft\Classes\AppID -y  Interactive User -r
@echo 获取权限....
"%~dp0data\tools\SetACL.exe" -on "HKLM\PE-SOFT" -ot reg -actn ace -ace "n:Everyone;p:full"


echo 导出注册表单元
::reg export hklm\pe-soft %~dp0fix_soft.reg /y


echo 卸载精简版注册表单元
reg unload hklm\pe-soft
reg unload hklm\os-soft
reg unload hklm\install-soft
if exist %~dp0 move /y %~dp0software_out out\SOFTWARE
rd /q /f %~dp0data\temp
cls 
echo 生成的精简文件已经复制到out目录
pause
exit

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::供调用

:load_install
if not exist "%~dp0data\temp" md "%~dp0data\temp"
"%~dp0data\tools\wimlib-imagex.exe" extract "%wimdir%" 4 \Windows\System32\config\software --dest-dir="%~dp0data\temp" --nullglob --no-acls
reg load hklm\install-soft "%~dp0data\temp\software"
exit /b


:explorer_support
echo 原生壳支持,复制必要的software注册表到空注册表
for /f "tokens=*" %%e in (%~dp0data\reg\explorer_ActivatableClassID.txt) do (
echo %%e
reg copy "hklm\os-soft\%%e" "hklm\pe-soft\%%e" /S /F
if errorlevel 1 reg copy "hklm\install-soft\%%e" "hklm\pe-soft\%%e" /S /F
)


echo 原生壳支持,复制必要的software注册表到空注册表
for /f "tokens=*" %%e in (%~dp0data\reg\explorer_clsid.txt) do (
echo %%e
reg copy "hklm\os-soft\%%e" "hklm\pe-soft\%%e" /S /F
if errorlevel 1 reg copy "hklm\install-soft\%%e" "hklm\pe-soft\%%e" /S /F
)

echo 原生壳支持,复制必要的software注册表到空注册表
for /f "tokens=*" %%e in (%~dp0data\reg\explorer_qunzhu.txt) do (
echo %%e
reg copy "hklm\os-soft\%%e" "hklm\pe-soft\%%e" /S /F
if errorlevel 1 reg copy "hklm\install-soft\%%e" "hklm\pe-soft\%%e" /S /F
)
exit /b


