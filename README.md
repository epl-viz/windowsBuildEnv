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
 
# Build Wireshark

Follow instructions [here](https://www.wireshark.org/docs/wsdg_html_chunked/ChSetupWin32.html), but STOP at "Generate the build files".

Edit the `buildWS.bat` script in WS_Root and set "<QT_ROOT>" to your Qt root. Run the script to run CMake.

Then load the Wireshark.sln in wsbuild64 and build the target BUILD_ALL and then INSTALL.

Finally, run `fixWSInstall.bat` in WS_Root to fix the wireshark installation.

# Build tinyxml2

Open the tinyxml2 Folder in VS2017 (File->Open->Folder).

Then go to CMake->Change CMake Settings and open the config file.

Insert `-DCMAKE_INSTALL_PREFIX=<REPO_ROOT>/install` in cmakeCommandArgs for the 64bit Release.

Build - and install - the project as x64-Release.

# Build EPL_DataCollect

Install cython via `pip install cython`.

Open the EPL_DataCollect folder in VS2017 and change the 64bit release cmake options to 

```bash
-DWIRESHARK_BASE_DIR=<REPO_ROOT>/WS_Root -DWireshark_DIR=<REPO_ROOT>/install/lib/Wireshark -DTinyXML2_ROOT=<REPO_ROOT>/install -DCMAKE_INSTALL_PREFIX=<REPO_ROOT>/install -T host=x64
```

then build and install the project.

# Install EPL-Viz

## Install Qwt

Download [Qwt 6.1.3](https://sourceforge.net/projects/qwt/files/qwt/6.1.3/) and extract.

Edit the `qwtconfig.pri` in `qwt-6.1.3` and set the `QWT_INSTALL_PREFIX` to `<REPO_ROOT>/install`

Then open the Qwt project in QtCreator, select the MSVC 2017 Qt 5.9 version (not the UWP).

Then go to project, select Release, and add a build step (make) with argument install.

Then run the `fixQwtInstall.bat` script in the root folder of the repository to fix the Qwt installation.

## Install EPL-Viz

Open the EPL-Viz folder in Visual Studio and set the following CMake parameters of the 64bit release:

```bash
-DWIRESHARK_BASE_DIR=<REPO_ROOT>/WS_Root -DWireshark_DIR=<REPO_ROOT>/install/lib/Wireshark -DTinyXML2_ROOT=<REPO_ROOT>/install -DQt5_DIR=<QT_ROOT>/5.9/msvc2017_64/lib/cmake/Qt5 -DCMAKE_INSTALL_PREFIX=<REPO_ROOT>/install -T host=x64
```

Build and install the project.

Edit `fixEPLInstall.bat` in the root folder of the repository, setting <QT_ROOT> to the Qt root folder. Run it to finish installing EPL-Viz.

## Creating an MSI installer

Download the [Python 3.6.1 standalone here](https://www.python.org/ftp/python/3.6.1/python-3.6.1-embed-amd64.zip) and extract it.

It is recommended to use a seperate build configuration based on x64-Release, which can be done by simply copying the configuration section and renaming it to x64-Deploy. 

Add the following flags to the CMake args of x64-Deploy: `-DENABLE_PACK=ON -DPTHON_BINARY_DIR=<PYTHON_PATH>`, wherein <PYTHON_PATH> is the path to the extracted python standalone.

:warning: **DO NOT BUILD THE `INSTALL` TARGET IN VISUAL STUDIO using these flags!** :warning:

Rebuild the project, then open a powershell in the CMake build folder (Where the EPL-Viz.sln is) and run

```bash
cpack -G WIX -C Release
```

:warning: chocolatey also has an .exe called cpack, you might have to resolve this conflict.

