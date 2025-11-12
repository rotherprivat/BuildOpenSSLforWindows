@echo off

rem openssl version
set opensslversion=3.5.4
set openssltag=openssl-%opensslversion%

rem Tools
rem Strawberry Perl latest working 5.32.1.1
rem See https://strawberryperl.com
set sbversion=5.42.0.1
set sbfolder=SP_54201_64bit
set sbperl=strawberry-perl-%sbversion%
set sbperlzip=%sbperl%-64bit-portable.zip

rem nasm
set nasmversion=3.01
set nasm=nasm-%nasmversion%
set nasmzip=%nasm%-win64.zip

rem Visual Studio // precondition
set VCX64=C:\Programme\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat

chdir /d %~dp0

mkdir tools
chdir tools

rem Get Strawberry Perl for windows
if exist "%sbperl%\" goto setperlenv
echo Getting: %sbperlzip%
curl -s -L -o "%sbperlzip%" "https://github.com/StrawberryPerl/Perl-Dist-Strawberry/releases/download/%sbfolder%/%sbperlzip%"
IF %ERRORLEVEL% NEQ 0 exit /b %errorlevel%

mkdir "%sbperl%"
tar -xf "%sbperlzip%" -C "%sbperl%"
IF %ERRORLEVEL% NEQ 0 exit /b %errorlevel%

:setperlenv

call "%sbperl%\portableshell.bat" /SETENV

echo Installed: %sbperl%

rem Get NASM for windows
if exist "%nasm%\" goto setnasmenv
echo Getting: %nasm%
curl -s -o "%nasmzip%" "https://www.nasm.us/pub/nasm/releasebuilds/%nasmversion%/win64/%nasmzip%"
IF %ERRORLEVEL% NEQ 0 exit /b %errorlevel%

tar -xf "%nasmzip%"
IF %ERRORLEVEL% NEQ 0 exit /b %errorlevel%

:setnasmenv

set PATH=%cd%\%nasm%;%PATH%

echo Installed: %nasm%

rem Visual Studio environment
call "%VCX64%"
IF %ERRORLEVEL% NEQ 0 exit /b %errorlevel%

chdir ..
mkdir "%openssltag%"
chdir "%openssltag%"

rem Get openssl source code

echo Cloning %openssltag%
git clone --depth 1 --branch "%openssltag%" "https://github.com/openssl/openssl.git"
IF %ERRORLEVEL% NEQ 0 exit /b %errorlevel%

mkdir deploy
set deploy=%cd%\deploy

cd openssl

rem configure openssl 
perl Configure --prefix="%deploy%" --openssldir="%deploy%" VC-WIN64A no-ssl3 no-comp no-idea no-weak-ssl-ciphers
IF %ERRORLEVEL% NEQ 0 exit /b %errorlevel%

rem build
nmake
IF %ERRORLEVEL% NEQ 0 exit /b %errorlevel%

rem run tests
nmake test
IF %ERRORLEVEL% NEQ 0 exit /b %errorlevel%

rem deploy build
nmake install

rem copy static libs
copy /y libssl_static.lib %deploy%\lib
copy /y libcrypto_static.lib %deploy%\lib
copy /y ossl_static.pdb %deploy%\lib

exit /b %errorlevel%
