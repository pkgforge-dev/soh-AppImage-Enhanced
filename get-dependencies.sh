#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	boost         \
	cmake         \
	fmt           \
	imagemagick   \
	libogg        \
	libpng        \
	libvorbis     \
	libzip        \
	lsb-release   \
	ninja         \
	nlohmann-json \
	opusfile      \
	sdl2          \
	sdl2_net      \
	spdlog        \
	tinyxml2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
make-aur-package zenity-rs-bin

# If the application needs to be manually built that has to be done down here
echo "Building soh..."
echo "---------------------------------------------------------------"
git clone https://github.com/HarbourMasters/Shipwright ./Shipwright && (
	cd ./Shipwright

	git fetch --tags origin
	TAG=$(git tag --sort=-v:refname | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | head -1)
	git checkout "$TAG"
	git submodule update --init --recursive

	# GCC 16 compilation patch
	sed -i '1a #include <cstdint>' libultraship/include/ship/window/MouseStateManager.h

	cmake ./ \
		-Bbuild \
		-GNinja \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/opt/soh \
		-DBUILD_REMOTE_CONTROL=1

	cmake --build build --target ZAPD
	cmake --build build --target GenerateSohOtr
	cmake --build build --target soh

	cmake --install build --component ship
	cmake --install build --component extractor

	echo "$TAG" > ~/version
)

mkdir -p ./AppDir/bin
mv -v /opt/soh/* ./AppDir/bin
