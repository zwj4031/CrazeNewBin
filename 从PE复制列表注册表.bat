reg load hklm\os-soft dp0software
reg load hklm\os-sys dp0system
reg load hklm\os-soft dp0software_out
reg load hklm\os-sys dp0system_out



title  复制版本相关的system注册表到PE
for /f "tokens=*" %%c in (%~dp0reglist.txt) do (
echo %%c
reg copy "hklm\os-soft\%%c" "hklm\pe-soft\%%c" /S /F
)

for /f "tokens=*" %%c in (%~dp0reglist.txt) do (
echo %%c
reg copy "hklm\os-sys\%%c" "hklm\pe-sys\%%c" /S /F
)
pause