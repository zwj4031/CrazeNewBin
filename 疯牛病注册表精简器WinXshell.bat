@echo off
cd /d "%~dp0"
if not "x%TRUSTEDINSTALLER%"=="x1" (
    set TRUSTEDINSTALLER=1
    "%~dp0data\tools\NSudo.exe" -U:T -P:E -Wait -UseCurrentConsole cmd /c "%~0"
    ::pause
     exit
    goto :EOF
)





echo .���ڳ�ʼ��....
echo ���ע������õ�Ԫ����
for %%a in (install-soft os-drv os-soft os-sys pe-drv pe-sys pe-soft pe-def) do (
set item=%%a
call :checkitem %item%
)
goto startplay

:checkitem
reg query hklm |find "%item%"
if "%errorlevel%" == "0" echo ���ڲ�����ֵ%item%, ж��.&&reg unload hklm\%item%>nul
if "%errorlevel%" == "1" echo δ�������
exit /b



:startplay
echo ���������ʼ��
:init

echo .���ҹ��̷���
set cddir=
for %%a in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (
if exist %%a:\sources\install.wim set wimdir=%%a:\sources\install.wim
if exist %%a:\sources\install.esd set wimdir=%%a:\sources\install.esd
)
if not "%wimdir%" == "" echo �Զ�����������ע���%wimdir%&&call :load_install

if not exist %~dp0software echo ��ǰĿ¼û���ҵ����ע���(software)&&pause&&exit
echo ��ʼ����3M�����software��������
:nextplay


rem ���ؿ�ע���Ԫ
reg load hklm\pe-soft %~dp0software_out
rem ��������ע������õ�Ԫ
reg load hklm\os-soft %~dp0software
rem ԭ����֧��
::call :explorer_support



echo ���Ʊ�Ҫ��softwareע�����ע���
for /f "tokens=*" %%e in (%~dp0data\reg\pe-soft-winxshell-mini.txt) do (
echo %%e
reg copy "hklm\os-soft\%%e" "hklm\pe-soft\%%e" /S /F
if errorlevel 1 reg copy "hklm\install-soft\%%e" "hklm\pe-soft\%%e" /S /F
)

echo ���Ʊ�Ҫ��softwareע������ע���
for /f "tokens=*" %%e in (%~dp0data\reg\pe+soft.txt) do (
echo %%e
reg copy "hklm\os-soft\%%e" "hklm\pe-soft\%%e" /F
if errorlevel 1 reg copy "hklm\install-soft\%%e" "hklm\pe-soft\%%e" /F
)

rem ע����Դ����
echo �޲�ע���
for /f %%r in ('dir /b %~dp0data\fix\*.reg') do (
echo ����ע����� %~dp0data\fix\%%r
reg import %~dp0data\fix\%%r
)


echo �滻c/dΪx��ɾ��Interactive User
"%~dp0data\tools\regfind" -p HKEY_LOCAL_MACHINE\pe-soft -y C:\ -y -r X:\
"%~dp0data\tools\regfind" -p HKEY_LOCAL_MACHINE\pe-soft -y D:\ -y -r X:\
"%~dp0data\tools\regfind" -p HKEY_LOCAL_MACHINE\pe-soft\Classes\AppID -y  Interactive User -r
@echo ��ȡȨ��....
"%~dp0data\tools\SetACL.exe" -on "HKLM\PE-SOFT" -ot reg -actn ace -ace "n:Everyone;p:full"


echo ����ע���Ԫ
::reg export hklm\pe-soft %~dp0fix_soft.reg /y


echo ж�ؾ����ע���Ԫ
reg unload hklm\pe-soft
reg unload hklm\os-soft
reg unload hklm\install-soft
if exist %~dp0 move /y %~dp0software_out out\SOFTWARE
rd /q /f %~dp0data\temp
cls 
echo ���ɵľ����ļ��Ѿ����Ƶ�outĿ¼
pause
exit

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::������

:load_install
if not exist "%~dp0data\temp" md "%~dp0data\temp"
"%~dp0data\tools\wimlib-imagex.exe" extract "%wimdir%" 4 \Windows\System32\config\software --dest-dir="%~dp0data\temp" --nullglob --no-acls
reg load hklm\install-soft "%~dp0data\temp\software"
exit /b


:explorer_support
echo ԭ����֧��,���Ʊ�Ҫ��softwareע�����ע���
for /f "tokens=*" %%e in (%~dp0data\reg\explorer_ActivatableClassID.txt) do (
echo %%e
reg copy "hklm\os-soft\%%e" "hklm\pe-soft\%%e" /S /F
if errorlevel 1 reg copy "hklm\install-soft\%%e" "hklm\pe-soft\%%e" /S /F
)


echo ԭ����֧��,���Ʊ�Ҫ��softwareע�����ע���
for /f "tokens=*" %%e in (%~dp0data\reg\explorer_clsid.txt) do (
echo %%e
reg copy "hklm\os-soft\%%e" "hklm\pe-soft\%%e" /S /F
if errorlevel 1 reg copy "hklm\install-soft\%%e" "hklm\pe-soft\%%e" /S /F
)

echo ԭ����֧��,���Ʊ�Ҫ��softwareע�����ע���
for /f "tokens=*" %%e in (%~dp0data\reg\explorer_qunzhu.txt) do (
echo %%e
reg copy "hklm\os-soft\%%e" "hklm\pe-soft\%%e" /S /F
if errorlevel 1 reg copy "hklm\install-soft\%%e" "hklm\pe-soft\%%e" /S /F
)
exit /b


