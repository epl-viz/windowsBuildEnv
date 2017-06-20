@echo off

setlocal

::Set <QT_ROOT> to the root folder of Qt
set QT_DIR=<QT_ROOT>\5.9\msvc2017_64\bin 

::Copy a missing dll to the bin folder
xcopy "%QT_DIR%\Qt5OpenGL.dll" "%~dp0\install\bin" > NUL

endlocal