@echo off

::
:: Batch Installer
::

:: Get administrator privileges
%1 echo Set objShell = CreateObject("Shell.Application")                   >  "Admin.vbs"
%1 echo objShell.ShellExecute "cmd.exe", "/C %~s0 :: %CD%", "", "runas", 1 >> "Admin.vbs"
%1 echo WScript.Quit                                                       >> "Admin.vbs"
%1 call "Admin.vbs" && del /F /Q "Admin.vbs"
%1 exit

:: Get local mirror address
set InstallerPATH=%2
set MirrorsPATH=%InstallerPATH:~0,-10%

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

:: Get the package list
    :: Delete files that may remain
del /Q "%SystemRoot%\Temp\pkgList_3.txt"
    :: Gets the list of packages in the local mirror
dir /B /ON "%MirrorsPATH%"                     > "%SystemRoot%\Temp\pkgList_1.txt"
findstr .bat "%SystemRoot%\Temp\pkgList_1.txt" > "%SystemRoot%\Temp\pkgList_2.txt"
del /Q "%SystemRoot%\Temp\pkgList_1.txt"
    :: Splicing Complete Script Path
for /F "delims=" %%i IN (%SystemRoot%\Temp\pkgList_2.txt) DO (
    >> "%SystemRoot%\Temp\pkgList_3.txt" echo "%MirrorsPATH%\%%i"
)
del /Q "%SystemRoot%\Temp\pkgList_2.txt"

:: Package in the installation list
for /F "delims=" %%j IN (%SystemRoot%\Temp\pkgList_3.txt) DO (
    :: Install
    call %%j "%MirrorsPATH%" i

    :: Reinstall
    ::call %%j "%MirrorsPATH%" r

    :: Uninstall
    ::call %%j "%MirrorsPATH%" u
)
del /Q "%SystemRoot%\Temp\pkgList_3.txt"

:: Delete the copied temporary decoder
del /Q "%SystemRoot%\system32\7z.dll"
del /Q "%SystemRoot%\system32\7z.exe"
