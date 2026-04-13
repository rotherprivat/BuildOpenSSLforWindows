@echo off
set script_root=%~dp0
chdir /d "%script_root%"

for /F "eol=; tokens=*" %%g in (%script_root%versions.config) do (set %%g)

rem openssl version
rem set OPENSSL_VERSION_MAJOR_MINOR=3.5
rem set OPENSSL_VERSION_PATCH=6
set openssltag=openssl-%OPENSSL_VERSION_MAJOR_MINOR%.%OPENSSL_VERSION_PATCH%

if not exist "%openssltag%" mkdir "%openssltag%"

rem Base Path
if "%~1" NEQ "-R" goto check_basepath
if "%~2"=="" echo Missing ctx && exit /b -1

set deploy=%cd%\%openssltag%\deploy
if not exist "%deploy%" mkdir "%deploy%"

set OSSL_WINCTX=%~2
set DOSSL_WINCTX=-DOSSL_WINCTX=%OSSL_WINCTX%

goto get_tools
:check_basepath
if "%~1" NEQ "-B" echo Unknown or missing option %~1 && exit /b -1

if "%~2"=="" echo Missing base path && exit /b -1

rem check for existing base path
if not exist "%~2\" echo Base path does not exist && exit /b -1

set deploy=%~2\%openssltag%
set OSSL_WINCTX=
set DOSSL_WINCTX=

:get_tools
echo Output folder: %deploy%
echo CTX: %OSSL_WINCTX%

rem Tools

rem vswhere always latest, no special versioning

rem Strawberry Perl latest working 5.42.2.1
rem See https://strawberryperl.com
rem set STRAWBERRY_PERL_VERSION=5.42.2.1
set sbfolder=SP_%STRAWBERRY_PERL_VERSION:.=%_64bit
set sbperl=strawberry-perl-%STRAWBERRY_PERL_VERSION%
set sbperlzip=%sbperl%-64bit-portable.zip

rem nasm
rem set NASM_VERSION=3.01
set nasm=nasm-%NASM_VERSION%
set nasmzip=%nasm%-win64.zip

if not exist tools mkdir tools
chdir tools

rem Visual Studio // precondition get path by vswhere.exe
rem set VSWHERE_VERSION=3.1.7
set vswhere=vswhere-%VSWHERE_VERSION%

if exist "%vswhere%\" goto setvcx64env
echo Getting: vswhere.exe
mkdir "%vswhere%"
curl -s -L -o "%vswhere%\vswhere.exe" "https://github.com/Microsoft/vswhere/releases/download/%VSWHERE_VERSION%/vswhere.exe"
IF %ERRORLEVEL% NEQ 0 echo Failed to download vswhere && exit /b %errorlevel%

:setvcx64env
for /f "delims=" %%i in ('%vswhere%\vswhere.exe -latest -property InstallationPath') do (
	set VCX64=%%i\VC\Auxiliary\Build\vcvars64.bat
)

rem Get Strawberry Perl for windows
if exist "%sbperl%\" goto setperlenv
echo Getting: %sbperlzip%
curl -s -L -o "%sbperlzip%" "https://github.com/StrawberryPerl/Perl-Dist-Strawberry/releases/download/%sbfolder%/%sbperlzip%"
IF %ERRORLEVEL% NEQ 0 echo Failed to download Strawberry Perl && exit /b %errorlevel%

mkdir "%sbperl%"
tar -xf "%sbperlzip%" -C "%sbperl%"
IF %ERRORLEVEL% NEQ 0 echo Failed to unzip Strawberry Perl && exit /b %errorlevel%

:setperlenv

call "%sbperl%\portableshell.bat" /SETENV

echo Installed: %sbperl%

rem Get NASM for windows
if exist "%nasm%\" goto setnasmenv
echo Getting: %nasm%
curl -s -o "%nasmzip%" "https://www.nasm.us/pub/nasm/releasebuilds/%NASM_VERSION%/win64/%nasmzip%"
IF %ERRORLEVEL% NEQ 0 echo Failed to download nasm && exit /b %errorlevel%

tar -xf "%nasmzip%"
IF %ERRORLEVEL% NEQ 0 echo Failed to unzip nasm && exit /b %errorlevel%

:setnasmenv

set PATH=%cd%\%nasm%;%PATH%

echo Installed: %nasm%

rem Visual Studio environment
call "%VCX64%"
IF %ERRORLEVEL% NEQ 0 echo Failed to set Visual Studio environment && exit /b %errorlevel%

chdir ..
chdir "%openssltag%"

rem Get openssl source code

echo Cloning %openssltag%
git clone --depth 1 --branch "%openssltag%" "https://github.com/openssl/openssl.git"
IF %ERRORLEVEL% NEQ 0 echo Failed to clone %openssltag% && exit /b %errorlevel%

cd openssl

rem configure openssl 
perl Configure %DOSSL_WINCTX% --prefix="%deploy%" --openssldir="%deploy%\ssl" VC-WIN64A no-ssl3 no-comp no-idea no-weak-ssl-ciphers
IF %ERRORLEVEL% NEQ 0 echo Failed to configure openssl && exit /b %errorlevel%

rem build
nmake
IF %ERRORLEVEL% NEQ 0 echo Failed to build openssl && exit /b %errorlevel%

rem run tests
nmake test
IF %ERRORLEVEL% NEQ 0 echo Failed to build or run openssl tests && exit /b %errorlevel%

rem deploy build
nmake install
IF %ERRORLEVEL% NEQ 0 echo Failed to deploy openssl && exit /b %errorlevel%

rem copy static libs
echo libssl_static.lib
copy /y libssl_static.lib "%deploy%\lib"
echo libcrypto_static.lib
copy /y libcrypto_static.lib "%deploy%\lib"
echo ossl_static.pdb
copy /y ossl_static.pdb "%deploy%\lib"


:register
rem add register and unregister batch to deployment
chdir "%script_root%"

rem ready if compiled base path
if "%OSSL_WINCTX%" == "" exit /b %errorlevel%

echo register.bat
copy /y install\register.bat "%deploy%"
echo unregister.bat
copy /y install\unregister.bat "%deploy%"

echo Building: ossl_reg.config 
(
echo OPENSSL_VERSION_MAJOR_MINOR=%OPENSSL_VERSION_MAJOR_MINOR%
echo OSSL_WINCTX=%OSSL_WINCTX%
) >%deploy%\ossl_reg.config

exit /b %errorlevel%
