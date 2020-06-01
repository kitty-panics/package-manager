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
    taskkill /F /T /IM "gvim.exe"
    taskkill /F /T /IM "vim.exe"
    taskkill /F /T /IM "vimrun.exe"
    taskkill /F /T /IM "vimtutor.bat"

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

    :: Cancel file association
        :: 纯文本
    assoc .txt=
    ftype txtfile="%%1" "%%*"
    assoc .ini=
    ftype inifile="%%1" "%%*"
    assoc .yaml=
    ftype yamlfile="%%1" "%%*"
        :: 标记语言
    assoc .md=
    ftype mdfile="%%1" "%%*"
    assoc .htm=
    ftype htmfile="%%1" "%%*"
    assoc .css=
    ftype cssfile="%%1" "%%*"
    assoc .xml=
    ftype xmlfile="%%1" "%%*"
        :: 编程语言
    assoc .c=
    ftype cfile="%%1" "%%*"
    assoc .h=
    ftype hfile="%%1" "%%*"
    assoc .java=
    ftype javafile="%%1" "%%*"
    assoc .js=
    ftype jsfile="%%1" "%%*"
    assoc .py=
    ftype pyfile="%%1" "%%*"
    assoc .json=
    ftype jsonfile="%%1" "%%*"
    assoc .vim=
    ftype vimfile="%%1" "%%*"
GOTO:EOF

:Execute_Reinstall
    :: Install this application
    7z x "%FilePath%\%FileName%.7z" -o"%HOMEDRIVE%\MyProgram\%FileName%" -aoa
GOTO:EOF

:Execute_Install
    :: Install this application
    7z x "%FilePath%\%FileName%.7z" -o"%HOMEDRIVE%\MyProgram\%FileName%" -aoa

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

    :: Set file association
        :: 纯文本
    assoc .txt=txtfile
    ftype txtfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .ini=inifile
    ftype inifile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .yaml=yamlfile
    ftype yamlfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
        :: 标记语言
    assoc .md=mdfile
    ftype mdfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .htm=htmfile
    ftype htmfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .css=cssfile
    ftype cssfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .xml=xmlfile
    ftype xmlfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
        :: 编程语言
    assoc .c=cfile
    ftype cfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .h=hfile
    ftype hfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .java=javafile
    ftype javafile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .js=jsfile
    ftype jsfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .py=pyfile
    ftype pyfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .json=jsonfile
    ftype jsonfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
    assoc .vim=vimfile
    ftype vimfile="%HOMEDRIVE%\MyProgram\%FileName%\gvim.exe" "%%1" "%%*"
GOTO:EOF
