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
    taskkill /F /T /IM "cpp.exe"
    taskkill /F /T /IM "g++.exe"
    taskkill /F /T /IM "gcc.exe"
    taskkill /F /T /IM "gdb.exe"

    :: Uninstall old version
    rd /S /Q "%HOMEDRIVE%\MyProgram\%FileName%"

    :: Delete environment variables
    echo set EV = WScript.CreateObject("WScript.Shell")          >  "DelSysEnvVar.vbs"
    echo dim SysEnvVar,SystemPath,AppPath                        >> "DelSysEnvVar.vbs"
    echo SysEnvVar = EV.Environment("process").Item("HOMEDRIVE") >> "DelSysEnvVar.vbs"
    echo SystemPath = EV.Environment("system").Item("Path")      >> "DelSysEnvVar.vbs"
    echo AppPath = ";"+SysEnvVar+"\MyProgram\%FileName%\bin"     >> "DelSysEnvVar.vbs"
    echo SystemPath = Replace(SystemPath,AppPath,"")             >> "DelSysEnvVar.vbs"
    echo EV.Environment("system").Item("Path") = SystemPath      >> "DelSysEnvVar.vbs"
    call "DelSysEnvVar.vbs" && del /F /Q "DelSysEnvVar.vbs"
GOTO:EOF

:Execute_Reinstall
    :: Install this application
    7z x "%FilePath%\%FileName%.7z" -o"%HOMEDRIVE%\MyProgram\%FileName%" -aoa
GOTO:EOF

:Execute_Install
    :: Install this application
    7z x "%FilePath%\%FileName%.7z" -o"%HOMEDRIVE%\MyProgram\%FileName%" -aoa

    :: Setting environment variables
    echo set EV = WScript.CreateObject("WScript.Shell")                        >  "SetSysEnvVar.vbs"
    echo dim SysEnvVar,SystemPath,AppName,NewSysPath                           >> "SetSysEnvVar.vbs"
    echo SysEnvVar = EV.Environment("process").Item("HOMEDRIVE")               >> "SetSysEnvVar.vbs"
    echo SystemPath = EV.Environment("system").Item("Path")                    >> "SetSysEnvVar.vbs"
    echo AppName = "%FileName%"                                                >> "SetSysEnvVar.vbs"
    echo if Instr(SystemPath,AppName) > 1 then                                 >> "SetSysEnvVar.vbs"
    echo     WScript.quit                                                      >> "SetSysEnvVar.vbs"
    echo else                                                                  >> "SetSysEnvVar.vbs"
    echo     NewSysPath = SystemPath+";"+SysEnvVar+"\MyProgram\%FileName%\bin" >> "SetSysEnvVar.vbs"
    echo     EV.Environment("system").Item("Path") = NewSysPath                >> "SetSysEnvVar.vbs"
    echo end if                                                                >> "SetSysEnvVar.vbs"
    call "SetSysEnvVar.vbs" && del /F /Q "SetSysEnvVar.vbs"
GOTO:EOF
