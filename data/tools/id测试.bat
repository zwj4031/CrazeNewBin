reg query HKEY_LOCAL_MACHINE\pe-soft\Microsoft\WindowsRuntime\ActivatableClassID>%temp%\ActivatableClassID.txt
for /f %%a in (%temp%\ActivatableClassID.txt) do (
call :checkdll %%a
)
pause
:checkdll
set classid=%1
for /f "tokens=1-3 delims= " %%i in ('reg query %classid% /v dllpath') do (
if exist %%k echo %classid%>>S:\havefile.txt
)
