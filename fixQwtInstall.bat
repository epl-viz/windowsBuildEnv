@echo off

::Move the remaining two .dlls over into the bin folder, overwriting if necessary
xcopy "%~dp0\install\lib\qwt.dll" "%~dp0\install\bin" /q /y > NUL
xcopy "%~dp0\install\lib\qwtd.dll" "%~dp0\install\bin" /q /y  > NUL