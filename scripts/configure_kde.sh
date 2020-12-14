#!/bin/bash

# Script to show the existing at jobs of the user invoking the script.

# For KDE (tested on KDE v5.54)
# Set lock screen clock to a 24hour format - check kcmshell5 "screenlocker"
sed -i 's/DateTime"])/DateTime"], "hh:mm:ss")/' /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/components/Clock.qml

