# Build OpenSSL V3.0.x for Windows X64 / Visual Studio VC++

This script builds OpenSSL V3.x.y dynamic- and static- libraries and application

## Precondition

- Windows 10 1803 or later (curl and tar is required)
- Git for Windows
- Visual Studio 2017 or later
    - including VC++ (Desktop development) MSVC >= V14


## Additional tools

The script will automatically download and configure

- Strawberry perl portable V5.42.0.1
- NASM V3.01

Please check [srawberry.com](https://strawberryperl.com) and [nasm.us](https://www.nasm.us) for current version and update GetAndBuildOpenssl.bat if needed.

## Update OpenSSL Version

Change Variable "opensslversion=3.x.y" to the required version in GetAndBuildOpenssl.bat

## Build

- From desktop system: simply execute "Startbuild.bat"
- From build pipeline execute GetAndBuildOpenssl.bat 

## Build result

The build output is copied to openssl-<version>\deploy. The source folder "openssl-<version>\openssl" can be deleted afer successfull build.
