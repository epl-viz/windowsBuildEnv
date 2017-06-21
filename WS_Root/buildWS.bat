@echo off

setlocal

::Set required variables for Wireshark
set CYGWIN=nodosfilewarning
set WIRESHARK_BASE_DIR=%~dp0
set WIRESHARK_TARGET_PLATFORM=win64
set QT5_BASE_DIR=%WIRESHARK_BASE_DIR%\..\install 

cd %WIRESHARK_BASE_DIR%

::Create the build folder if it does not exist yet
if not exist wsbuild64 mkdir wsbuild64

cd wsbuild64

::Run CMake
cmake -DENABLE_CHM_GUIDES=off -G "Visual Studio 15 2017 Win64" -DCMAKE_INSTALL_PREFIX="%WIRESHARK_BASE_DIR%\..\install" "%WIRESHARK_BASE_DIR%\wireshark" -T host=x64

endlocal
