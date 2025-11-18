# Build OpenSSL V3.x.y for Windows X64 / Visual Studio VC++

This script builds OpenSSL V3.x.y dynamic- and static- libraries and application

## Precondition

- Windows 10 1803 or later (curl and tar are required)
- Git for Windows
- Visual Studio 2017 or later
    - including VC++ (Desktop development) MSVC >= V14

## Additional tools

The script will automatically download and configure

- Microsoft vswhere (latest) [vswhere](https://github.com/microsoft/vswhere)
- Strawberry perl portable (V5.42.0.1): [srawberryperl.com](https://strawberryperl.com)
- NASM (V3.01): [nasm.us](https://www.nasm.us)

Please check the tools above for the actual versions and update the version, folder names and download URLs in GetAndBuildOpenssl.bat.

These tools are downloaded from their respective official sources as part of the build process. Users are responsible for complying with the licensing terms of these third-party tools.

## Disclaimer

This build script automates the download and execution of third-party tools including Strawberry Perl, NASM, and Microsoft vswhere, among others. These components are downloaded from their respective official sources.

**Use at your own risk.**  
The author(s) of this script do not guarantee the safety, integrity, or authenticity of third-party binaries. Always verify downloaded files and review external sources for any potential security risks.

The author(s) are not liable for any damages, malfunctions, data loss, or security issues arising from use of this script or any software it downloads.

## Update OpenSSL Version

Change Variable "opensslversion=3.x.y" to the required version in GetAndBuildOpenssl.bat.

## Build

Find a base path to deploy your OpenSSL build. For example "C:\program files\openssl". Please note: the build account needs write access to this folder.

- From desktop system: execute Startbuild.bat "\<deploy-base-path\>"
- From build pipeline: call GetAndBuildOpenssl.bat "\<deploy-base-path\>"

## Build result

The build output is copied to \<deploy-base-path\>\\openssl-\<version\>. The source folder ".\\openssl-\<version\>" can be deleted after successful build.
