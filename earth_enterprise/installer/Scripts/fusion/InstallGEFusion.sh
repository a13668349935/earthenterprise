#!/bin/bash
#
# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This script runs basic tests for installation then runs the
# installer for
# Google Earth Enterprise Fusion
# Usage: InstallGEFusion[GUI].sh [silent_installer_file]
# an argument to this script is interpretted as the silent installer file.
# Note: this is the only line difference between InstallGEFusion.sh and InstallGEFusionGUI.sh
mode=console

installer_binary=GEFusion.bin
product_name="Google Earth Enterprise Fusion"

# Check that all GEE Services are stopped.
testresult=`./.installer/CheckGEEStopped.sh`
if [ -n "$testresult" ]; then
    echo -e "$testresult"
    exit # can't continue
fi

testresult=`./.installer/CheckDiskSpace.sh 1000000 1GB`
echo -e "$testresult"

testresult=`./.installer/CheckHostTypeIs64bit.sh`
if [ -n "$testresult" ]; then
    echo -e "$testresult"
    exit # can't continue
fi

testresult=`./.installer/CheckRootUser.sh "$product_name"`
if [ -n "$testresult" ]; then
    echo -e "$testresult"
    exit # can't continue
fi

# X11 test (optional for installing, required for Fusion UI)
error_title="Warning: X11 is not running and is required for the Fusion UI."
error_message="    You will need X11 to run the UI for $product_name"

testresult=`./.installer/CheckX11.sh "$error_title" "$error_message"`
if [ -n "$testresult" ]; then
    echo -e "$testresult"
    # don't exit, continue with the installation
fi

# Run the installer
if [ $1 ]
then
    mode=$1
fi
echo "Installing $product_name"
./.installer/RunInstaller.sh "$product_name" "$installer_binary" "$mode"
