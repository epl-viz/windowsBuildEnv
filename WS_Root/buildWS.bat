@echo off

set CYGWIN=nodosfilewarning
set WIRESHARK_BASE_DIR=%~dp0
set WIRESHARK_TARGET_PLATFORM=win64
set QT5_BASE_DIR=C:\Qt\5.9\msvc2017_64

cd wsbuild64
cmake -DENABLE_CHM_GUIDES=off -G "Visual Studio 15 2017 Win64" -DCMAKE_INSTALL_PREFIX=%WIRESHARK_BASE_DIR%\..\install ..\wireshark
