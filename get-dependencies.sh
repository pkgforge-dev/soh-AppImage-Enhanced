#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    boost         \
    cmake         \
    fmt           \
    python        \
    libdecor      \
    libzip        \
    lsb-release   \
    ninja         \
    nlohmann-json \
    opusfile      \
    sdl2          \
    sdl2_net      \
    spdlog        \
    tinyxml2      \
    valijson
    #websocketpp

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package zenity-rs-bin

# If the application needs to be manually built that has to be done down here
echo "Making stable build of Shipwright..."
echo "---------------------------------------------------------------"
REPO="https://github.com/HarbourMasters/Shipwright"
VERSION="$(git ls-remote --tags --sort="v:refname" "$REPO" | tail -n1 | sed 's/.*\///; s/\^{}//')"
git clone --branch "$VERSION" --single-branch --recursive --depth 1 "$REPO" ./Shipwright
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./Shipwright
cmake . \
    -Bbuild \
    -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DNON_PORTABLE=On \
    -DENABLE_OPENSSL=OFF \
    -DBUILD_REMOTE_CONTROL=1
cmake --build build --target ZAPD --config Release
cmake --build build --target GenerateSohOtr
cmake --build build --target soh --config Release
#cmake --install build --component extractor

mv -v build/assets ../AppDir/bin
mv -v build/soh/soh.elf ../AppDir/bin/soh
mv -v build/soh/soh.o2r ../AppDir/bin
wget -O ../AppDir/bin/gamecontrollerdb.txt https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/master/gamecontrollerdb.txt
cp -rv soh/macosx/sohIcon.png /usr/share/pixmaps/soh.png
