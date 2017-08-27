@echo off

setlocal enabledelayedexpansion

set SRC=%1
set BUILD_ROOT=%~dp0
set EXTRACTED=FALSE

if not exist qwt-* ( 
    echo Could not find the qwt source folder
    echo Please ensure the folder follows the name
    endlocal
    exit /B
)

cd "%BUILD_ROOT%"

:: Checking for cygwin
for %%I IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
  for %%J IN (%%I:\Cygwin %%I:\Cygwin64 %%I:\tools\Cygwin %%I:\tools\Cygwin64) DO (
    if EXIST "%%J" set CYG_DIR=%%J
  )
)

if "%CYG_DIR%"=="NOTFOUND" (
  :: Try to find cygwin via path by locating Cygstart.exe
  for %%I in (Cygstart.exe) do (
   set CYG_START=%%~dp$PATH:I
  )
  
  if NOT "%CYG_START%"=="" (
    set CYG_DIR=%CYG_START:~0,-4%
  )
  
  :: Check if cygwin was in path
  if "%CYG_DIR%"=="NOTFOUND" (
    echo "UNABLE TO FIND CYGWIN"
    echo "Add the cygwin/bin folder to your path or set the path manually in this file."
    endlocal
    exit /B
  )
)

echo Found cygwin: %CYG_DIR%

set SED_EXE=%CYG_DIR%\bin\sed.exe
set TAR_EXE=%CYG_DIR%\bin\tar.exe
set ECHO_EXE=%CYG_DIR%\bin\echo.exe
set QMAKE_EXE=%BUILD_ROOT%\install\bin\qmake.exe
set JOM_EXE=%BUILD_ROOT%\install\dev-utils\bin\jom.exe

for %%I IN (%SED_EXE% %ECHO_EXE% %QMAKE_EXE% %JOM_EXE%) DO (
  if NOT EXIST "%%I" (
    echo "UNABLE TO FIND %%I"
    endlocal
    exit /B
  )
)

echo Found sed:    %SED_EXE%
echo Found echo:   %ECHO_EXE%
echo Found qmake:  %QMAKE_EXE%
echo Found jom:    %JOM_EXE%

cd qwt-*

%ECHO_EXE% -n %BUILD_ROOT% > tmp.txt

"%SED_EXE%" -i "s/\\\\/\\\\\\\\\\//g" tmp.txt
set /P out=<tmp.txt

"%SED_EXE%" -i "s/QWT_INSTALL_PREFIX[ ]*=.*$/QWT_INSTALL_PREFIX = %out%\\/install/g" qwtconfig.pri
set QWT_PATH="%cd%"

%ECHO_EXE% "CONFIG-=debug"   >> qwtconfig.pri
%ECHO_EXE% "CONFIG+=release" >> qwtconfig.pri

cd ..
if NOT EXIST build_qmake mkdir build_qmake
cd build_qmake
"%QMAKE_EXE%" %QWT_PATH%\qwt.pro -spec win32-msvc "CONFIG-=debug" "CONFIG+=release"
"%JOM_EXE%" qmake_all
"%JOM_EXE%"
"%JOM_EXE%" install
"%JOM_EXE%"
"%JOM_EXE%" install

xcopy "%~dp0\install\lib\qwt.dll" "%~dp0\install\bin" /q /y > NUL

endlocal
