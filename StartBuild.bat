@echo off
call GetAndBuildOpenssl.bat "%~1"

IF %ERRORLEVEL% == 0 goto end

echo Build Failed

:end

pause