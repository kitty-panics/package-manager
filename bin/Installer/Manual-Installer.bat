@echo off

::
:: Manual Installer
::

:: Get administrator privileges
%1 start "" mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit

:: Setting the local mirror address
set Mirrors="C:|D:|E:|F:\XXXX\YYYY\ZZZZ\TTTTT\HHHHHH"
set InstallerPath="%Mirrors%\Installer"

:: Copy temporary decoder
copy /Y "%InstallerPath%\7z.dll" "%SystemRoot%\system32"
copy /Y "%InstallerPath%\7z.exe" "%SystemRoot%\system32"

:: Create the necessary directories
md "%HOMEDRIVE%\MyProgram\Shortcut"

:: Set environment variables for the directory of the shortcut
echo set EV = WScript.CreateObject("WScript.Shell")                  >  "SetSysEnvVar.vbs"
echo dim SysEnvVar,SystemPath,AppName,NewSysPath                     >> "SetSysEnvVar.vbs"
echo SysEnvVar = EV.Environment("process").Item("HOMEDRIVE")         >> "SetSysEnvVar.vbs"
echo SystemPath = EV.Environment("system").Item("Path")              >> "SetSysEnvVar.vbs"
echo AppName = "Shortcut"                                            >> "SetSysEnvVar.vbs"
echo if Instr(SystemPath,AppName) > 1 then                           >> "SetSysEnvVar.vbs"
echo     WScript.quit                                                >> "SetSysEnvVar.vbs"
echo else                                                            >> "SetSysEnvVar.vbs"
echo     NewSysPath = SystemPath+";"+SysEnvVar+"\MyProgram\Shortcut" >> "SetSysEnvVar.vbs"
echo     EV.Environment("system").Item("Path") = NewSysPath          >> "SetSysEnvVar.vbs"
echo end if                                                          >> "SetSysEnvVar.vbs"
call "SetSysEnvVar.vbs" && del /F /Q "SetSysEnvVar.vbs"

:: Install the specified package
    :: Package name
set /p PackageName=PLEASE ENTER THE PACKAGE NAME:
    :: Order: i(Install) | r(Reinstall) | u(Uninstall)
set /p WhatOrder=PLEASE SELECT THE ORDER:
    :: Start installation
call "%Mirrors%\%PackageName%.bat" %Mirrors% %WhatOrder%

:: Delete the copied temporary decoder
del /Q "%SystemRoot%\system32\7z.dll"
del /Q "%SystemRoot%\system32\7z.exe"
