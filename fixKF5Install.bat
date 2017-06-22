@echo off

setlocal

set KDE_ROOT=C:\KDE
set INSTALL_ROOT=%~dp0\install

robocopy "%KDE_ROOT%\include"   "%INSTALL_ROOT%\include"   * /S /NJH /NFL /NDL
robocopy "%KDE_ROOT%\bin"       "%INSTALL_ROOT%\bin"       * /S /NJH /NFL /NDL
robocopy "%KDE_ROOT%\lib"       "%INSTALL_ROOT%\lib"       * /S /NJH /NFL /NDL
robocopy "%KDE_ROOT%\share"     "%INSTALL_ROOT%\share"     * /S /NJH /NFL /NDL
robocopy "%KDE_ROOT%\plugins"   "%INSTALL_ROOT%\plugins"   * /S /NJH /NFL /NDL
robocopy "%KDE_ROOT%\mkspecs"   "%INSTALL_ROOT%\mkspecs"   * /S /NJH /NFL /NDL
robocopy "%KDE_ROOT%\dev-utils" "%INSTALL_ROOT%\dev-utils" * /S /NJH /NFL /NDL

endlocal