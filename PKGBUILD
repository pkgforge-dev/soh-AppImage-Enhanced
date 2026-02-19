# Maintainer: AltoXorg <atrl101 AT yahoo DOT com>

_reponame=Shipwright
_lus_commit=a8bdcab363571038bb71f195f21ec3e9033a220d
_ZAPDTR_commit=684f21a475dcfeee89938ae1f4afc42768a3e7ef
_OTRExporter_commit=32e088e28c8cdd055d4bb8f3f219d33ad37963f3

pkgbase=soh
pkgname=(soh soh-otr-exporter)
pkgver=9.1.2
pkgrel=1
arch=("x86_64" "aarch64")
url="https://shipofharkinian.com/"
_depends_soh=("sdl2" "sdl2_net" "zenity" "libzip" "libpng" "libogg" "libvorbis" "opus" "opusfile")
_depends_soh_otr_exporter=("libpng")
_depends_lus=("fmt" "spdlog" "tinyxml2")  # libzip could be placed here, but ZAPD.out didn't made to use it
depends=("${_depends_soh[@]}" "${_depends_soh_otr_exporter[@]}" "${_depends_lus[@]}")
makedepends=("git" "cmake" "ninja" "python" "curl" "lsb-release" "boost" "nlohmann-json")
options=('!debug' 'strip')
source=("${_reponame}-${pkgver}.tar.gz::https://github.com/HarbourMasters/${_reponame}/archive/refs/tags/${pkgver}.tar.gz"
        "libultraship-${_lus_commit:0:8}.tar.gz::https://github.com/Kenix3/libultraship/archive/${_lus_commit}.tar.gz"
        "ZAPDTR-${_ZAPDTR_commit:0:8}.tar.gz::https://github.com/HarbourMasters/ZAPDTR/archive/${_ZAPDTR_commit}.tar.gz"
        "OTRExporter-${_OTRExporter_commit:0:8}.tar.gz::https://github.com/HarbourMasters/OTRExporter/archive/${_OTRExporter_commit}.tar.gz"
        "soh.desktop")
sha256sums=('c8ef222945595f3119dad127f3a0be41b7755a2df519b008f99a2abe5c1ee0bd'
            '7361e5283faf39747e5eab010a4ae37dbc544bbd9e04d034179fca475f71cbe0'
            '8016f735f9ef4e177384b0e51f243e374bf2f67ba66bdd5d21af8b185aed1635'
            '91a863f8899f2ebfc7868ccad4b5982ae416799c76358ce5b2c0edc11e42a672'
            'aa1632a4deb5796c1cd92c1b748016b2c2077e82564d2428e3d55db54fde1c48')

SHIP_PREFIX=/opt/soh

prepare() {
  cd "${srcdir}/${_reponame}-${pkgver}"

  rm -r libultraship ZAPDTR OTRExporter
  cp -r ../libultraship-${_lus_commit} libultraship
  cp -r ../ZAPDTR-${_ZAPDTR_commit} ZAPDTR
  cp -r ../OTRExporter-${_OTRExporter_commit} OTRExporter
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
  install -Dm644 "${srcdir}/soh.desktop" -t "${pkgdir}/usr/share/applications"
  install -Dm644 soh/macosx/sohIcon.png "${pkgdir}/usr/share/pixmaps/soh.png"
}

package_soh-otr-exporter() {
  pkgdesc="OTR generation tools for SoH. Includes asset XML files needed for generation."
  license=("MIT")
  depends=("${_depends_soh_otr_exporter[@]}" "${_depends_lus[@]}")

  cd "${srcdir}/${_reponame}-${pkgver}"

  DESTDIR="${pkgdir}" cmake --install build --component extractor
}
