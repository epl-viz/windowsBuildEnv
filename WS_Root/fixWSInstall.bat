@echo off

setlocal

set WS_BASE_DIR=%~dp0
set WS_INCLUDE_DIR=%WS_BASE_DIR%\..\install\include\wireshark
set WS_LIB_DIR=%WS_BASE_DIR%\..\install\bin

echo Copying header files...

::Copy header files, except cfile.h to the WS include dir
robocopy "%WS_BASE_DIR%\wireshark" %WS_INCLUDE_DIR% *.h /S /XF "cfile.h" /NJH /NDL /NFL /NJS > NUL

::Check if user built Wireshark correctly
if not exist "%WS_BASE_DIR%wsbuild64\run\Release" (
    echo Could not locate "%WS_BASE_DIR%wsbuild64\run\Release"
    echo Please ensure you have built Wireshark as x64 release
    exit /B
)

echo Copying built dlls...

::Copy built dlls to the WS lib dir.
robocopy "%WS_BASE_DIR%wsbuild64\run\Release" "%WS_LIB_DIR%" *.dll /S /NJH /NDL /NFL /NJS > NUL

endlocal