#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/pixmaps/soh.png
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/soh /usr/bin/soh-otr-exporter /usr/bin/zenity
#mv /opt/soh/soh.o2r ./AppDir/bin
#mv /opt/soh/gamecontrollerdb.txt ./AppDir/bin
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
