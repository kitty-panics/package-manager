@echo off

::
:: Template
::

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
    taskkill /F /T /IM "PROGRAM_NAME.exe"

    :: Uninstall old version
    rd /S /Q "%HOMEDRIVE%\MyProgram\%FileName%"

    :: Delete environment variables
    echo set EV = WScript.CreateObject("WScript.Shell")          >  "DelSysEnvVar.vbs"
    echo dim SysEnvVar,SystemPath,AppPath                        >> "DelSysEnvVar.vbs"
    echo SysEnvVar = EV.Environment("process").Item("HOMEDRIVE") >> "DelSysEnvVar.vbs"
    echo SystemPath = EV.Environment("system").Item("Path")      >> "DelSysEnvVar.vbs"
    echo AppPath = ";"+SysEnvVar+"\MyProgram\%FileName%"         >> "DelSysEnvVar.vbs"
    echo SystemPath = Replace(SystemPath,AppPath,"")             >> "DelSysEnvVar.vbs"
    echo EV.Environment("system").Item("Path") = SystemPath      >> "DelSysEnvVar.vbs"
    call "DelSysEnvVar.vbs" && del /F /Q "DelSysEnvVar.vbs"

    :: Delete shortcut
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\SHORTCUT_NAME.lnk"

    :: Cancel file association
    assoc .FILE_TYPE_NAME=
    ftype FILE_TYPE_ALIAS="%%1" "%%*"

    :: Other files to be deleted (Optional)
    ::rd /S /Q  "ABSOLUTE_PATH_OF_FILE_DIRECTORY"
    ::del /F /Q "ABSOLUTE_PATH_OF_FILE"
GOTO:EOF

:Execute_Reinstall
    :: Install this application
    7z x "%FilePath%\%FileName%.7z" -o"%HOMEDRIVE%\MyProgram\%FileName%" -aoa
    ::reg IMPORT "ABSOLUTE_PATH\REGISTRY_TO_IMPORT.reg"
    ::start /W "" pkgmgr /ip /m:"ABSOLUTE_PATH\CAB_PROGRAM_TO_BE_INSTALLED.cab"
GOTO:EOF

:Execute_Install
    :: Install this application
    7z x "%FilePath%\%FileName%.7z" -o"%HOMEDRIVE%\MyProgram\%FileName%" -aoa
    ::reg IMPORT "ABSOLUTE_PATH\REGISTRY_TO_IMPORT.reg"
    ::start /W "" pkgmgr /ip /m:"ABSOLUTE_PATH\CAB_PROGRAM_TO_BE_INSTALLED.cab"

    :: Setting environment variables
    echo set EV = WScript.CreateObject("WScript.Shell")                    >  "SetSysEnvVar.vbs"
    echo dim SysEnvVar,SystemPath,AppName,NewSysPath                       >> "SetSysEnvVar.vbs"
    echo SysEnvVar = EV.Environment("process").Item("HOMEDRIVE")           >> "SetSysEnvVar.vbs"
    echo SystemPath = EV.Environment("system").Item("Path")                >> "SetSysEnvVar.vbs"
    echo AppName = "%FileName%"                                            >> "SetSysEnvVar.vbs"
    echo if Instr(SystemPath,AppName) > 1 then                             >> "SetSysEnvVar.vbs"
    echo     WScript.quit                                                  >> "SetSysEnvVar.vbs"
    echo else                                                              >> "SetSysEnvVar.vbs"
    echo     NewSysPath = SystemPath+";"+SysEnvVar+"\MyProgram\%FileName%" >> "SetSysEnvVar.vbs"
    echo     EV.Environment("system").Item("Path") = NewSysPath            >> "SetSysEnvVar.vbs"
    echo end if                                                            >> "SetSysEnvVar.vbs"
    call "SetSysEnvVar.vbs" && del /F /Q "SetSysEnvVar.vbs"

    :: Create shortcut
    echo set SC = WScript.CreateObject("WScript.Shell")                                         >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\SHORTCUT_NAME.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\MyProgram\%FileName%\MAIN_PROGRAM_NAME.exe"       >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\MyProgram\%FileName%\MAIN_PROGRAM_NAME.exe,0"   >> "Shortcut.vbs"
    echo oShellLink.Save                                                                        >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"

    :: Set file association
    assoc .FILE_TYPE_NAME=FILE_TYPE_ALIAS
    ftype FILE_TYPE_ALIAS="THE_ABSOLUTE_PATH_OF_THE_PROGRAM_USED_TO_OPEN_THIS_FILE_TYPE.exe|.bat|.cmd" "%%1" "%%*"

    :: Set up startup
    copy /Y "ABSOLUTE_PATH\PROGRAMS_THAT_NEED_TO_BE_RUN_AT_BOOT_TIME.exe|.bat|.cmd" "%HOMEDRIVE%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"

    :: Run the application now
    start "" "%HOMEDRIVE%\MyProgram\%FileName%\MAIN_PROGRAM_NAME.exe"

    :: Analog key click
    echo set WshShell = WScript.CreateObject("WScript.Shell")           >  "KeyClick.vbs"
    echo dim SystemPath                                                 >> "KeyClick.vbs"
    echo SystemPath = WshShell.Environment("process").Item("HOMEDRIVE") >> "KeyClick.vbs"
    echo WshShell.Run THE_ABSOLUTE_PATH_OF_THE_PROGRAM_TO_RUN           >> "KeyClick.vbs"
    echo WScript.Sleep WAIT_TIME_IN_MILLISECONDS                        >> "KeyClick.vbs"
    echo WshShell.SendKeys "{KEYS_THAT_NEED_TO_BE_SENT,SUCH_AS_ENTER}"  >> "KeyClick.vbs"
    echo WScript.Sleep WAIT_TIME_IN_MILLISECONDS                        >> "KeyClick.vbs"
    echo WshShell.SendKeys "{KEYS_THAT_NEED_TO_BE_SENT,SUCH_AS_ENTER}"  >> "KeyClick.vbs"
    call "KeyClick.vbs" && del /F /Q "KeyClick.vbs"
GOTO:EOF
