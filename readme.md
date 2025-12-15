# Build OpenSSL V3.x.y for Windows X64 / Visual Studio VC++

This script builds OpenSSL V3.x.y dynamic- and static- libraries and application.

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

Change the variables "opensslmajorversion=3.x" and "opensslminorversion=y" to the required version in GetAndBuildOpenssl.bat.
For example to "opensslmajorversion=3.5" and "opensslminorversion=4" this will build the OpenSSL version 3.5.4.

## Build

- From desktop system: execute Startbuild.bat \<option\> <\param\>
- From build pipeline: call GetAndBuildOpenssl.bat \<option\> <\param\>

The script can be used to build OpenSSL in two different variants:

### Fixed base-path

Find a base path to deploy your OpenSSL build. For example: "C:\program files\openssl".
Please note: the build account needs write access to this folder. 

The path is compiled into the OpenSSL binaries and can only be overwritten by environment variables. This is suitable for local deployments, or if only the crypto libraries are required.

#### Run build

To run the build, execute one of the scripts above with option=-B and param="\<deploy-base-path\>"

```cmd
Startbuild.bat -B "C:\program files\openssl"
```
Example: Execute build with fixed base-path.


#### Build result

The build output is copied to "\<deploy-base-path\>\\openssl-\<version\>". The source folder ".\\openssl-\<version\>" can be deleted after successful build.

### Registry defined paths

Define a context name “\<WINCTX\>", that can be used to identify “your” OpenSSL deployment. For example "MyOssl". No paths are compiled into the OpenSSL binaries; the required paths are specified later in the windows registry. 
See: [OpenSSL Windows-Installation](https://github.com/openssl/openssl/blob/openssl-3.5.4/NOTES-WINDOWS.md#installation-directories).

#### Run build

To run the build, execute one of the scripts above with option=-R and param="\<WINCTX\>"

```cmd
Startbuild.bat -R "MyOssl"
```
Example: Execute build with registry defined paths.

#### Build result

The build output is copied to ".\\openssl-\<version\>\\deploy". The source folder ".\\openssl-\<version\>\openssl" can be deleted after successful build.

#### Installation

The build result can be used to deploy the OpenSSL binaries with a windows installer (not part of this project).

Nevertheless, you can take the following steps to manually install OpenSSL:
1. Copy the build output (".\\openssl-\<version\>\\deploy") to the installation folder. For example: "C:\program files\openssl".
2. Run “register.bat” as administrator from the installation folder 
3. Before deleting your OpenSSL installation, you should run “unregister.bat” to remove unused registry keys and – values.
