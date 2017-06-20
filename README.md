# windowsBuildEnv

This is a meta repository designed to build EPL-Viz on Windows.

# Required software

 - Visual Studio 2017
 - CMake 3.8
 - Python 3.6.1
 
:warning: Make sure that python is installed in a path that **does NOT contain any spaces** :warning:
 
# Build Wireshark

Follow instructions [here](https://www.wireshark.org/docs/wsdg_html_chunked/ChSetupWin32.html), but STOP at "Generate the build files".

Use the buildWS.bat script in WS_Root to run CMake.

Then load the Wireshark.sln in wsbuild64 and build the target BUILD_ALL and then INSTALL.

Then run `TODO INSERT SCRIPT HERE` to fix the wireshark installation.

# Build tinyxml2

and open the tinyxml2 Folder in VS2017 (File->Open->Folder).
Then goto CMake->Change CMake Settings and open the config file

Insert `-DCMAKE_INSTALL_PREFIX=<Path/to/this/Repo>/install` in cmakeCommandArgs for the 64bit Release.
Build - and install - the project as x64-Release.

# Build EPL_DataCollect

Install cython via `pip install cython`

and open the Folder in VS2017 and chanche the 64bit release cmake options to 

```bash
-DWIRESHARK_BASE_DIR=<Path/to/this/Repo>/WS_Roor -DWireshark_DIR=<Path/to/this/Repo>/install/lib/Wireshark -DTinyXML2_ROOT=<Path/to/this/Repo>/install -DCMAKE_INSTALL_PREFIX=<Path/to/this/Repo>/install -T host=x64
```

then build and install the project

# Install EPL-Viz

## Install Qwt

Download Qwt: https://sourceforge.net/projects/qwt/files/qwt/6.1.3/

Edit the qwtconfig.pri in qwt-6.1.3 and set the `QWT_INSTALL_PREFIX` to `<Path/to/this/Repo>/install`

Then open the Qwt project in QtCreator, select the MSVC Qt version (not the UWP).
Then go to project, select Release, and add a build step (make) with argument install

Then run `TODO INSERT SCRIPT HERE` script to fix the qwt installation

## Install EPL-Viz

Open the EPL-Viz folder in Visual Studio and set the following CMake parameters:
```
-DWIRESHARK_BASE_DIR=<Path/to/this/Repo>/WS_Root -DWireshark_DIR=<Path/to/this/Repo>/install/lib/Wireshark -DTinyXML2_ROOT=<Path/to/this/Repo>/install -DQt5_DIR=C:/Qt/5.9/msvc2017_64/lib/cmake/Qt5 -DCMAKE_INSTALL_PREFIX=<Path/to/this/Repo>/install -DUSE_KTEXTEDITOR=OFF -T host=x64
```

Build and install the project, then use `TODO INSERT SCRIPT HERE` to finish installing EPL-Viz.

## Creating a MSI

Download the [python standalone here](https://www.python.org/ftp/python/3.6.1/python-3.6.1-embed-amd64.zip) and extract it.

Add the following flags to the CMake args: `-DENABLE_PACK=ON -DPTHON_BINARY_DIR=C:/Path/to/python-3.6.1`

:warning: **DO NOT BUILD THE `INSTALL` TARGET IN VISUAL STUDIO** :warning:

Rebuild the project, then open a powershell in the CMake build folder (Where the EPL-Viz.sln is) and run
```
cpack -G WIX -C Release
```

:warning: choclaty also has an exe called cpack, you might have to resolve this conflict.

