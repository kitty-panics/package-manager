@echo off

:: Get parameters - local mirror address
set FilePath=%1
:: Get parameters - order
set Order=%2
:: Get Parameters - the file name of the current Batch file
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
    echo "I don't know why i added this function."
    echo "Only know that script can't run correc-"
    echo "tly without this function."
    echo ""
    echo "Sad ~"
GOTO:EOF

:Execute_Uninstall
    :: Uninstall old version
    rd /S /Q "%HOMEDRIVE%\MyProgram\%FileName%"

    :: Delete environment variables
    echo set EV = WScript.CreateObject("WScript.Shell")          >  "DelSysEnvVar.vbs"
    echo dim SysEnvVar,SystemPath,AppPath                        >> "DelSysEnvVar.vbs"
    echo SysEnvVar = EV.Environment("process").Item("HOMEDRIVE") >> "DelSysEnvVar.vbs"
    echo SystemPath = EV.Environment("system").Item("Path")      >> "DelSysEnvVar.vbs"
    echo AppPath = SysEnvVar+"\MyProgram\%FileName%"+";"         >> "DelSysEnvVar.vbs"
    echo SystemPath = Replace(SystemPath,AppPath,"")             >> "DelSysEnvVar.vbs"
    echo EV.Environment("system").Item("Path") = SystemPath      >> "DelSysEnvVar.vbs"
    call "DelSysEnvVar.vbs" && del /F /Q "DelSysEnvVar.vbs"

    :: Delete shortcut
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\guh.lnk"
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\guw.lnk"
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\gux.lnk"
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\gup.lnk"
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\gum.lnk"
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\guv.lnk"
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\gud.lnk"
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\gmp.lnk"
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\dc.lnk"
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\jsq.lnk"
    del /F /Q "%HOMEDRIVE%\MyProgram\Shortcut\jsb.lnk"

    :: Cancel file association
        :: 自定义压缩格式
    assoc .aexe=
    ftype aexefile="%%1" "%%*"
        :: 通用的格式 (几乎所有压缩软件都支持的)
    assoc .zip=
    ftype zipfile="%%1" "%%*"
    assoc .rar=
    ftype rarfile="%%1" "%%*"
    assoc .7z=
    ftype 7zfile="%%1" "%%*"
        :: *nix 系统上常用格式
    assoc .tar=
    ftype tarfile="%%1" "%%*"
    assoc .gz=
    ftype gzfile="%%1" "%%*"
    assoc .gzip=
    ftype gzipfile="%%1" "%%*"
    assoc .tgz=
    ftype tgzfile="%%1" "%%*"
    assoc .xz=
    ftype xzfile="%%1" "%%*"
    assoc .lz=
    ftype lzfile="%%1" "%%*"
        :: 其它格式
    assoc .iso=
    ftype isofile="%%1" "%%*"
    assoc .001=
    ftype 001file="%%1" "%%*"
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
    echo     NewSysPath = SysEnvVar+"\MyProgram\%FileName%"+";"+SystemPath >> "SetSysEnvVar.vbs"
    echo     EV.Environment("system").Item("Path") = NewSysPath            >> "SetSysEnvVar.vbs"
    echo end if                                                            >> "SetSysEnvVar.vbs"
    call "SetSysEnvVar.vbs" && del /F /Q "SetSysEnvVar.vbs"

    :: Create shortcut
        :: 跳转到用户的主目录
    echo set SC = WScript.CreateObject("WScript.Shell")                               >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\guh.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\Users\%USERNAME%"                       >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\Users\%USERNAME%,0"                   >> "Shortcut.vbs"
    echo oShellLink.Save                                                              >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"
        :: 跳转到用户的文档目录
    echo set SC = WScript.CreateObject("WScript.Shell")                               >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\guw.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\Users\%USERNAME%\Documents"             >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\Users\%USERNAME%\Documents,0"         >> "Shortcut.vbs"
    echo oShellLink.Save                                                              >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"
        :: 跳转到下载目录
    echo set SC = WScript.CreateObject("WScript.Shell")                               >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\gux.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\Users\%USERNAME%\Downloads"             >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\Users\%USERNAME%\Downloads,0"         >> "Shortcut.vbs"
    echo oShellLink.Save                                                              >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"
        :: 跳转到用户的图片目录
    echo set SC = WScript.CreateObject("WScript.Shell")                               >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\gup.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\Users\%USERNAME%\Pictures"              >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\Users\%USERNAME%\Pictures,0"          >> "Shortcut.vbs"
    echo oShellLink.Save                                                              >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"
        :: 跳转到用户的音乐目录
    echo set SC = WScript.CreateObject("WScript.Shell")                               >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\gum.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\Users\%USERNAME%\Music"                 >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\Users\%USERNAME%\Music,0"             >> "Shortcut.vbs"
    echo oShellLink.Save                                                              >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"
        :: 跳转到用户的视频目录
    echo set SC = WScript.CreateObject("WScript.Shell")                               >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\guv.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\Users\%USERNAME%\Videos"                >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\Users\%USERNAME%\Videos,0"            >> "Shortcut.vbs"
    echo oShellLink.Save                                                              >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"
        :: 跳转到用户的桌面目录
    echo set SC = WScript.CreateObject("WScript.Shell")                               >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\gud.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\Users\%USERNAME%\Desktop"               >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\Users\%USERNAME%\Desktop,0"           >> "Shortcut.vbs"
    echo oShellLink.Save                                                              >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"
        :: 跳转到软件安装目录
    echo set SC = WScript.CreateObject("WScript.Shell")                               >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\gmp.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\MyProgram"                              >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\MyProgram,0"                          >> "Shortcut.vbs"
    echo oShellLink.Save                                                              >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"
        :: 打开磁盘清理工具
    echo set SC = WScript.CreateObject("WScript.Shell")                              >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\dc.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\Windows\system32\cleanmgr.exe"         >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\Windows\system32\cleanmgr.exe,0"     >> "Shortcut.vbs"
    echo oShellLink.Save                                                             >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"
        :: 打开计算器
    echo set SC = WScript.CreateObject("WScript.Shell")                               >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\jsq.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\Windows\system32\calc.exe"              >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\Windows\system32\calc.exe,0"          >> "Shortcut.vbs"
    echo oShellLink.Save                                                              >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"
        :: 打开记事本
    echo set SC = WScript.CreateObject("WScript.Shell")                               >  "Shortcut.vbs"
    echo set oShellLink = SC.CreateShortcut("%HOMEDRIVE%\MyProgram\Shortcut\jsb.lnk") >> "Shortcut.vbs"
    echo oShellLink.TargetPath = "%HOMEDRIVE%\Windows\notepad.exe"                    >> "Shortcut.vbs"
    echo oShellLink.IconLocation = "%HOMEDRIVE%\Windows\notepad.exe,0"                >> "Shortcut.vbs"
    echo oShellLink.Save                                                              >> "Shortcut.vbs"
    call "Shortcut.vbs" && del /F /Q "Shortcut.vbs"

    :: Set file association
        :: 自定义压缩格式
    assoc .aexe=aexefile
    ftype aexefile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
        :: 通用的格式 (几乎所有压缩软件都支持的)
    assoc .zip=zipfile
    ftype zipfile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
    assoc .rar=rarfile
    ftype rarfile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
    assoc .7z=7zfile
    ftype 7zfile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
        :: *nix 系统上常用格式
    assoc .tar=tarfile
    ftype tarfile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
    assoc .gz=gzfile
    ftype gzfile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
    assoc .gzip=gzipfile
    ftype gzipfile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
    assoc .tgz=tgzfile
    ftype tgzfile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
    assoc .xz=xzfile
    ftype xzfile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
    assoc .lz=lzfile
    ftype lzfile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
        :: 其它格式
    assoc .iso=isofile
    ftype isofile="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
    assoc .001=001file
    ftype 001file="%HOMEDRIVE%\MyProgram\%FileName%\AutomaticUnzip.bat" "%%1" "%%*"
GOTO:EOF
