# windowsBuildEnv

This is a meta repository designed to build EPL-Viz on Windows.

When starting out, make sure to also retrieve the submodules, which can be done by either using

```bash
git clone --recursive https://github.com/epl-viz/windowsBuildEnv.git
```

or using

```bash
git submodule update --init --recursive
```

on an already cloned repository.

Please note that any paths that have to be modified require '/' instead of '\'. Any scripts that require modification can use either path seperator.

# Required software

 - Visual Studio 2017
 - CMake 3.8
 - Python 3.6.1
 
:warning: Make sure that python is installed in a path that **does NOT contain any spaces** :warning:

# Building and installing dependencies

## Building KTextEditor and Qt5

EPL-Viz allows the usage of KTextEditor as a replacement for its default plugin editor. Building it will allow you to add the flag `-DUSE_KTEXTEDITOR=ON` to the EPL-Viz CMake build flags, enabling the use of the KTextEditor.

Download and install craft via
```ps1
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
(new-object net.webclient).DownloadFile('https://raw.githubusercontent.com/KDE/craft/master/setup/install_craft.ps1', (Get-Item -Path ".\" -Verbose).FullName + 'install_craft.ps1' )
.\install_craft.ps1 -branch master # Select x64 and the microsoft compiler
```

Then edit <CRAFTROOT>\etc\CraftSettings.ini:
  - Under `General`, set `ABI` to `windows-msvc2017_64-cl`
  - Under `QtSDK`, set `Version` to `5.9` (or higher) and `Compiler` to msvc2017

Now open the `x64 Native Tools Command Prompt for VS 2017` and run
```
<CRAFTROOT>\craft\kdeenv.bat
craft libs/qt5/qtmultimedia ktexteditor
```

Now cross your fingers and hope that none of the libraries (including Qt5) fails to build. The build process may take a while.

Once completed, run `fixKF5Install.bat`.
 
## Build Wireshark

Follow instructions [here](https://www.wireshark.org/docs/wsdg_html_chunked/ChSetupWin32.html), but STOP at "Generate the build files".

Run the `buildWS.bat` script to run CMake.

Then load the Wireshark.sln in wsbuild64, set the build configuration to x64-Release and build the target BUILD_ALL and then INSTALL.

Finally, run `fixWSInstall.bat` in WS_Root to complete the wireshark installation.

## Build Qwt

Download [Qwt 6.1.3](https://sourceforge.net/projects/qwt/files/qwt/6.1.3/) and extract the downloaded source into the build root.

Then run `buildQWT.bat`.

If there are build errors, try running `<CRAFTROOT>\craft\kdeenv.bat` in a different shell first.

## Build tinyxml2

Run `copyConfig.bat`

Open the tinyxml2 Folder in VS2017 (File->Open->Folder).

Build - and install - the project as x64-Release.

# Building and installing EPL-Viz

## Build EPL_DataCollect

Install cython via `pip install cython`.

Open the EPL_DataCollect folder in VS2017 and then build and install the project (as x64-Release).

## Build EPL-Viz

Open the EPL-Viz folder in Visual Studio and build and install the project.

### Creating an MSI installer

Download the [Python 3.6.1 standalone here](https://www.python.org/ftp/python/3.6.1/python-3.6.1-embed-amd64.zip) and extract it.

Download and install the latest [WiX Toolset build tools](http://wixtoolset.org/releases/).

Select the x64-Deploy build configuration

:warning: **DO NOT BUILD THE `INSTALL` TARGET IN VISUAL STUDIO using x64-Deploy!** :warning:

Rebuild the project, then open a powershell in the CMake build folder (Where the EPL-Viz.sln is) and run

```bash
cpack -G WIX -C Release
```

:warning: chocolatey also has an .exe called cpack, you might have to resolve this conflict.

