@echo off

setlocal

set KDE_ROOT=C:\KDE
set INSTALL_ROOT=%~dp0\install

robocopy "%KDE_ROOT%\include" "%INSTALL_ROOT%\include" * /S /NJH /NFL /NDL
robocopy "%KDE_ROOT%\bin"     "%INSTALL_ROOT%\bin"     * /S /NJH /NFL /NDL
robocopy "%KDE_ROOT%\lib"     "%INSTALL_ROOT%\lib"     * /S /NJH /NFL /NDL
robocopy "%KDE_ROOT%\share"   "%INSTALL_ROOT%\share"   * /S /NJH /NFL /NDL

endlocal