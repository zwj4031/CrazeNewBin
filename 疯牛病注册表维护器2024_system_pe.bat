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
for %%a in (install-sys os-drv install-sys install-sys pe-drv pe-sys pe-sys pe-def) do (
set item=%%a
call :checkitem %item%
)
goto startplay

:checkitem
reg query hklm |find "%item%"
if "%errorlevel%" == "0" echo ���ڲ�����ֵ%item%, ж��.&&reg unload hklm\%item%>nul
if "%errorlevel%" == "1" echo δ�������
exit /b

rd /q /f %~dp0data\temp

:startplay
echo ���������ʼ��
:init

echo .���ҹ��̷���
set cddir=
for %%a in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (
if exist %%a:\sources\boot.wim set wimdir=%%a:\sources\boot.wim
if exist %%a:\sources\install.wim set wimdir=%%a:\sources\install.wim
if exist %%a:\sources\install.esd set wimdir=%%a:\sources\install.esd

)
if not "%wimdir%" == "" echo �Զ�����������ע���%wimdir%&&call :load_install

if not exist %~dp0system echo ��ǰĿ¼û���ҵ����ע���(system)&&pause&&exit
echo ��ʼ����system��������
:nextplay

rem ����PEע���Ԫ
reg load hklm\pe-sys %~dp0system
rem ��������ע������õ�Ԫ
::reg load hklm\install-sys %~dp0data\temp\system
rem ԭ����֧��
::call :explorer_support
echo ���Ʊ�Ҫ��softע���peע���
for /f "tokens=*" %%e in (%~dp0data\reg-sys\system.txt) do (
echo %%e
reg copy "hklm\install-sys\%%e" "hklm\pe-sys\%%e" /S /F
rem if errorlevel 1 reg copy "hklm\install-sys\%%e" "hklm\pe-sys\%%e" /S /F
)

rem ע����Դ����
echo �޲�ע���
for /f %%r in ('dir /b %~dp0data\fix-soft\*.reg') do (
echo ����ע����� %~dp0data\fix-soft\%%r
reg import %~dp0data\fix-soft\%%r
)
echo �滻c/dΪx��ɾ��Interactive User
"%~dp0data\tools\regfind" -p HKEY_LOCAL_MACHINE\pe-sys -y C:\ -y -r X:\
"%~dp0data\tools\regfind" -p HKEY_LOCAL_MACHINE\pe-sys -y D:\ -y -r X:\
"%~dp0data\tools\regfind" -p HKEY_LOCAL_MACHINE\pe-sys\Classes\AppID -y  Interactive User -r
@echo ��ȡȨ��....
"%~dp0data\tools\SetACL.exe" -on "HKLM\pe-sys" -ot reg -actn ace -ace "n:Everyone;p:full"
echo ����ע���Ԫ
::reg export hklm\pe-sys %~dp0fix_soft.reg /y


echo ж�ؾ����ע���Ԫ
reg unload hklm\pe-sys
reg unload hklm\install-sys
if exist %~dp0 copy /y %~dp0system out\system
rd /q /f %~dp0data\temp
cls 
echo ���ɵ�ע����ļ��Ѿ����Ƶ�outĿ¼
pause
exit

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::������

:load_install
if not exist "%~dp0data\temp" md "%~dp0data\temp"
"%~dp0data\tools\wimlib-imagex.exe" extract "%wimdir%" 1 \Windows\System32\config\system --dest-dir="%~dp0data\temp" --nullglob --no-acls
reg load hklm\install-sys "%~dp0data\temp\system"

@echo ��ȡȨ��....
"%~dp0data\tools\SetACL.exe" -on "HKLM\install-sys" -ot reg -actn ace -ace "n:Everyone;p:full"
exit /b




