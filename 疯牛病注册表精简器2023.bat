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
start "" %~dp0bin\winxshell.exe -console -log -script %~dp0CrazeNewBin.lua
echo ���������ʼ��
pause
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

pause