@echo off
call GetAndBuildOpenssl.bat "%~1" "%~2"

IF %ERRORLEVEL% == 0 goto end

echo Build Failed

:end

pause