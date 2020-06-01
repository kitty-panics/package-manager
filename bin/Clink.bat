@echo off

:: Get parameters - local mirror address
set FilePath=%1
:: Get parameters - order
set Order=%2
:: Get Parameters - Self package name
set FileName=%~n0

:: Order judgement
if %Order% == u (
    call:Execute_Uninstall
) else if %Order% == r (
    call:Execute_Reinstall
) else if %Order% == i ( 
    call:Execute_Install
) else (
    echo "Unknown parameters."
)

:Unsolved_Mystery
    echo "I don't know why I added this function."
    echo "Only know that script can't run correc-"
    echo "tly without this function."
    echo ""
    echo "Sad ~"
GOTO:EOF

:Execute_Uninstall
    :: Stop running programs
    taskkill /F /T /IM "clink_x64.exe"
    taskkill /F /T /IM "clink_x86.exe"

    :: Uninstall old version
    rd /S /Q "%HOMEDRIVE%\MyProgram\%FileName%"
GOTO:EOF

:Execute_Reinstall
    :: Install this application
    7z x "%FilePath%\%FileName%.7z" -o"%HOMEDRIVE%\MyProgram\%FileName%" -aoa
GOTO:EOF

:Execute_Install
    :: Install this application
    7z x "%FilePath%\%FileName%.7z" -o"%HOMEDRIVE%\MyProgram\%FileName%" -aoa
    "%HOMEDRIVE%\MyProgram\%FileName%\clink_x64.exe" autorun install
GOTO:EOF
