@echo off

setlocal enabledelayedexpansion

::Set required variables for Wireshark
set CYGWIN=nodosfilewarning
set WIRESHARK_BASE_DIR=%~dp0
set WIRESHARK_TARGET_PLATFORM=win64

cd %WIRESHARK_BASE_DIR%

set CYG_DIR=NOTFOUND
  
:: Check for cygwin at default paths
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

:: Force usage of cygwin bash (Windows bash subsystem is incompatible)
set SH_EXE=%CYG_DIR%\bin\bash.exe
set SED_EXE=%CYG_DIR%\bin\sed.exe

if NOT EXIST "%SH_EXE%" (
  echo "UNABLE TO FIND BASH"
  exit /B
)

if NOT EXIST "%SED_EXE%" (
  echo "UNABLE TO FIND SED"
  exit /B
)

echo Found sed:    %SED_EXE%

for %%I IN (FindGTHREAD2.cmake FindGMODULE2.cmake) DO (
  set CURR_FILE="%WIRESHARK_BASE_DIR%\wireshark\cmake\modules\%%I"
  echo Fixing !CURR_FILE!
  %SED_EXE% -i "s/if([ ]*BUILD_wireshark[ ]*)/if( ON ) # Dirty hack to build WS without QT/g" !CURR_FILE!
)


::Create the build folder if it does not exist yet
if not exist wsbuild64 mkdir wsbuild64

cd wsbuild64

::Run CMake
cmake -DENABLE_CHM_GUIDES=off -DSH_EXECUTABLE="%SH_EXE%" -G "Visual Studio 15 2017 Win64" -DBUILD_wireshark=OFF -DCMAKE_INSTALL_PREFIX="%WIRESHARK_BASE_DIR%\..\install" "%WIRESHARK_BASE_DIR%\wireshark"

endlocal
