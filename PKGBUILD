# Maintainer: AltoXorg <atrl101 AT yahoo DOT com>

_reponame=Shipwright
_lus_commit=fdcaf6336776d24a6408d016b0a52243f108f250
_ZAPDTR_commit=ee3397a365c5f350a60538c88f0643f155944836
_OTRExporter_commit=32e088e28c8cdd055d4bb8f3f219d33ad37963f3

pkgbase=soh
pkgname=(soh soh-otr-exporter)
pkgver=9.2.3
pkgrel=1
arch=("x86_64" "aarch64")
url="https://shipofharkinian.com/"
_depends_soh=("imagemagick" "libogg" "libpng" "libvorbis" "libzip" "opus" "opusfile" "sdl2" "sdl2_net" "zenity")
_depends_soh_otr_exporter=("libpng")
_depends_lus=("fmt" "spdlog" "tinyxml2")  # libzip could be placed here, but ZAPD.out didn't made to use it
depends=("${_depends_soh[@]}" "${_depends_soh_otr_exporter[@]}" "${_depends_lus[@]}")
makedepends=("git" "cmake" "ninja" "python" "curl" "lsb-release" "boost" "nlohmann-json")
options=('!debug' 'strip')
source=("${_reponame}-${pkgver}.tar.gz::https://github.com/HarbourMasters/${_reponame}/archive/refs/tags/${pkgver}.tar.gz"
        "libultraship-${_lus_commit:0:8}.tar.gz::https://github.com/Kenix3/libultraship/archive/${_lus_commit}.tar.gz"
        "ZAPDTR-${_ZAPDTR_commit:0:8}.tar.gz::https://github.com/HarbourMasters/ZAPDTR/archive/${_ZAPDTR_commit}.tar.gz"
        "OTRExporter-${_OTRExporter_commit:0:8}.tar.gz::https://github.com/HarbourMasters/OTRExporter/archive/${_OTRExporter_commit}.tar.gz")
sha256sums=('84d1e00cdb76928a1295b04469d4e1f344f57a0a652186dd0c4c4075c25a0f66'
            '60add82e2211861075223387e694fc43e0c0dcb2b31a19b8895e0ed0b37250af'
            '555cb887dcdf5b9c76fbd703a9928de8792bc3d816253696cd52c2d8f2826601'
            '91a863f8899f2ebfc7868ccad4b5982ae416799c76358ce5b2c0edc11e42a672')

SHIP_PREFIX=/opt/soh

prepare() {
  cd "${srcdir}/${_reponame}-${pkgver}"

  rm -r libultraship ZAPDTR OTRExporter
  cp -r ../libultraship-${_lus_commit} libultraship
  cp -r ../ZAPDTR-${_ZAPDTR_commit} ZAPDTR
  cp -r ../OTRExporter-${_OTRExporter_commit} OTRExporter
  
  # GCC 16 compilation patch
  sed -i '1a #include <cstdint>' libultraship/include/ship/window/MouseStateManager.h
}

build() {
  cd "${srcdir}/${_reponame}-${pkgver}"
  BUILD_TYPE=Release

  CFLAGS="${CFLAGS/-Werror=format-security/}" \
  CXXFLAGS="${CXXFLAGS/-Werror=format-security/}" \
  cmake . \
    -Bbuild \
    -GNinja \
    -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
    -DNON_PORTABLE=On \
    -DCMAKE_INSTALL_PREFIX=$SHIP_PREFIX \
    -DBUILD_REMOTE_CONTROL=1

  cmake --build build --target ZAPD --config $BUILD_TYPE $NINJAFLAGS
  cmake --build build --target GenerateSohOtr $NINJAFLAGS
  cmake --build build --target soh --config $BUILD_TYPE $NINJAFLAGS
}

package_soh() {
  pkgdesc="An unofficial port of The Legend of Zelda Ocarina of Time for PC, Wii U, and Switch"
  depends=("${_depends_soh[@]}" "${_depends_lus[@]}")
  license=("unknown")

  cd "${srcdir}/${_reponame}-${pkgver}"

  DESTDIR="${pkgdir}" cmake --install build --component ship

  install -dm755 "${pkgdir}/usr/bin/"
  ln -s "${SHIP_PREFIX}/soh.elf" "${pkgdir}/usr/bin/soh"
  install -Dm644 "${srcdir}/${_reponame}-${pkgver}/build/soh/soh.o2r" "${pkgdir}/usr/bin/soh.o2r"
  install -Dm644 soh/macosx/sohIcon.png "${pkgdir}/usr/share/pixmaps/soh.png"
}

package_soh-otr-exporter() {
  pkgdesc="OTR generation tools for SoH. Includes asset XML files needed for generation."
  license=("MIT")
  depends=("${_depends_soh_otr_exporter[@]}" "${_depends_lus[@]}")

  cd "${srcdir}/${_reponame}-${pkgver}"

  DESTDIR="${pkgdir}" cmake --install build --component extractor
}
