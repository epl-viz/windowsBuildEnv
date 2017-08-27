@echo off

setlocal

set CRAFT_ROOT=NOTFOUND

:: Check for craft at default paths
for %%I IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
  for %%J IN (%%I:\CraftRoot) DO (
    if EXIST "%%J" set CRAFT_ROOT=%%J
  )
)

:: Check if detected, prompt manual entry if not
if "%CRAFT_ROOT%"=="NOTFOUND" (
    echo Could not find Craft installation at default path [Drive:\CraftRoot].
    GOTO user_prompt
)

:copy
    set INSTALL_ROOT=%~dp0\install

    echo Copying required files...

    robocopy "%CRAFT_ROOT%\include"   "%INSTALL_ROOT%\include"   * /S /NJH /NFL /NDL /NJS > NUL
    robocopy "%CRAFT_ROOT%\bin"       "%INSTALL_ROOT%\bin"       * /S /NJH /NFL /NDL /NJS > NUL
    robocopy "%CRAFT_ROOT%\lib"       "%INSTALL_ROOT%\lib"       * /S /NJH /NFL /NDL /NJS > NUL
    robocopy "%CRAFT_ROOT%\share"     "%INSTALL_ROOT%\share"     * /S /NJH /NFL /NDL /NJS > NUL
    robocopy "%CRAFT_ROOT%\plugins"   "%INSTALL_ROOT%\plugins"   * /S /NJH /NFL /NDL /NJS > NUL
    robocopy "%CRAFT_ROOT%\mkspecs"   "%INSTALL_ROOT%\mkspecs"   * /S /NJH /NFL /NDL /NJS > NUL
    robocopy "%CRAFT_ROOT%\dev-utils" "%INSTALL_ROOT%\dev-utils" * /S /NJH /NFL /NDL /NJS > NUL
    
    echo Done

    GOTO:eof

:user_prompt
    set /P CRAFT_ROOT="Please specify the path to the Craft Root directory: "
    
    if not exist "%CRAFT_ROOT%" (
        echo   Invalid path
        GOTO user_prompt
    )
    
    echo Trying "%CRAFT_ROOT%"
    GOTO copy

endlocal