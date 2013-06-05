#!/bin/sh
exec /bin/bash "$(dirname "$0")"/bootinst.sh
exec /bin/sh "$(dirname "$0")"/bootinst.sh

@echo off
COLOR 2F
cls
echo ===============================================================================
echo.
echo                            ________.__
echo                           /   ____/^|  ^| _____  ___  ___
echo                           \____  \ ^|  ^| \__  \ \  \/  /
echo                           /       \^|  ^|__/ __ \_^>    ^<
echo                          /______  /^|____(____  /__/\_ \
echo                                 \/           \/      \/
echo.
echo ===============================================================================
echo.

set DISK=none
set BOOTFLAG=boot666s.tmp

:checkPrivileges
mkdir "%windir%\SlaxAdminCheck" 2>nul
if '%errorlevel%' == '0' rmdir "%windir%\SlaxAdminCheck" & goto gotPrivileges else goto getPrivileges

:getPrivileges
ECHO.
ECHO                        Administrator Rights are required
ECHO                      Invoking UAC for Privilege Escalation
ECHO.
runadmin.vbs %0
goto end

:gotPrivileges
CD /D "%~dp0"

echo This file is used to determine current drive letter. It should be deleted. >\%BOOTFLAG%
if not exist \%BOOTFLAG% goto readOnly

echo.|set /p=wait please
for %%d in ( C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do echo.|set /p=. & if exist %%d:\%BOOTFLAG% set DISK=%%d
echo . . . . . . . . . .
del \%BOOTFLAG%
if %DISK% == none goto DiskNotFound

wscript.exe samedisk.vbs %windir% %DISK%
if %ERRORLEVEL% == 99 goto refuseDisk

echo Setting up boot record for %DISK%: ...

if %OS% == Windows_NT goto setupNT
goto setup95

:setupNT
\boot\syslinux.exe -maf -d /boot/ %DISK%:
if %ERRORLEVEL% == 0 goto setupDone
goto errorFound

:setup95
\boot\syslinux.com -maf -d /boot/ %DISK%:
if %ERRORLEVEL% == 0 goto setupDone
goto errorFound

:setupDone
echo Installation finished.
goto pauseit

:errorFound
color 4F
echo.
echo Error installing boot loader
goto pauseit

:refuseDisk
color 4F
echo.
echo Directory %DISK%:\boot\ seems to be on the same physical disk as your Windows.
echo Installing bootloader would harm your Windows and thus is disabled.
echo Please put Slax to a different drive and try again.
goto pauseit

:readOnly
color 4F
echo.
echo You're starting Slax installer from a read-only media, this will not work.
goto pauseit

:DiskNotFound
color 4F
echo.
echo Error: can't discover current drive letter

:pauseit
if "%1" == "auto" goto end

echo.
echo Press any key...
pause > nul

:end
