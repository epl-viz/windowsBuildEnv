@echo off

setlocal enabledelayedexpansion

set BASE_DIR=%~dp0

cd "%BASE_DIR%"

echo Copying configuration files...

for %%I IN (tinyxml2 EPL_DataCollect EPL-Viz) DO (
  set DIR=%BASE_DIR%%%I
  set FILE=%BASE_DIR%CMakeSettings_%%I.json
  set DEST=!DIR!\CMakeSettings.json
  if NOT EXIST "!DIR!" (
    echo "  !DIR! does not exist"
    endlocal
    exit /B
  )
  
  if NOT EXIST "!FILE!" (
    echo "  Config file !FILE! does not exist"
    endlocal
    exit /B
  )
  
  echo   Copying "!FILE!" to "!DEST!"
  copy "!FILE!" "!DEST!" > NUL
)

echo Done

endlocal
