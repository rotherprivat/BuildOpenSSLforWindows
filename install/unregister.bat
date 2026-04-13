@echo off
set BASE_PATH=%~dp0
for /F "tokens=*" %%g in (%BASE_PATH%ossl_reg.config) do (set %%g)

if "%OSSL_WINCTX%"=="" exit /b -1

set regKey=HKLM\SOFTWARE\Wow6432Node\OpenSSL-%OPENSSL_VERSION_MAJOR_MINOR%-%OSSL_WINCTX%
echo removing registry key:
echo [%regKey%]
pause

reg delete %regKey% /f
pause