#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	asio		  \
	boost         \
	cmake         \
	fmt           \
	imagemagick   \
	libzip        \
	lsb-release   \
	nlohmann-json \
	opusfile      \
	sdl2_net      \
	spdlog        \
	tinyxml2	  \
	valijson	  \
	websocketpp

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini opus-mini

make-aur-package zenity-rs-bin

echo "Building soh..."
echo "---------------------------------------------------------------"
REPO=https://github.com/HarbourMasters/Shipwright
VERSION=$(git ls-remote --tags --refs --sort=-v:refname "$REPO" | awk -F'/' '{print $NF; exit}')
git clone --branch "$VERSION" --single-branch --recursive --depth 1 "$REPO"
echo "$VERSION" > ~/version

cd ./Shipwright
cmake ./ -B build \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=/opt/soh \
	-DBUILD_REMOTE_CONTROL=1 \
	-DOPENSSL_ROOT_DIR=/usr \
	-DOPENSSL_CRYPTO_LIBRARY=/usr/lib/libcrypto.so \
	-DOPENSSL_SSL_LIBRARY=/usr/lib/libssl.so
cmake --build build --target ZAPD -j$(nproc)
cmake --build build --target GenerateSohOtr -j$(nproc)
cmake --build build --target soh -j$(nproc)
cmake --install build --component ship
cmake --install build --component extractor

mkdir -p ./AppDir/bin
mv -v /opt/soh/* ./AppDir/bin
