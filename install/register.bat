@echo off
set BASE_PATH=%~dp0
for /F "tokens=*" %%g in (%BASE_PATH%ossl_reg.config) do (set %%g)

if "%OSSL_WINCTX%"=="" exit /b -1

set regKey=HKLM\SOFTWARE\Wow6432Node\OpenSSL-%OPENSSL_VERSION_MAJOR_MINOR%-%OSSL_WINCTX%
echo Setting registry:
echo [%regKey%]
echo OPENSSLDIR="%BASE_PATH%ssl"
echo ENGINESDIR="%BASE_PATH%lib\engines-3"
echo MODULESDIR="%BASE_PATH%lib\ossl-modules"
pause

echo OPENSSLDIR:
reg add %regKey% /v OPENSSLDIR /t REG_SZ /d "%BASE_PATH%ssl" /f
echo ENGINESDIR:
reg add %regKey%  /v ENGINESDIR /t REG_SZ /d "%BASE_PATH%lib\engines-3" /f
echo MODULESDIR:
reg add %regKey%  /v MODULESDIR /t REG_SZ /d "%BASE_PATH%lib\ossl-modules" /f
pause