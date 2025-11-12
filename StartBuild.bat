@echo off
call GetAndBuildOpenssl.bat

IF %ERRORLEVEL% == 0 goto end

echo Build Failed

:end

pause