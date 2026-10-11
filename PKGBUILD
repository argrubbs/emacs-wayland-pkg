# Maintainer: Adam Grubbs <argrubbs>

pkgname=emacs-wayland
pkgver=31.1.20261010
pkgrel=1
pkgdesc='The extensible, customizable, self-documenting real-time display editor with PGTK and xwidgets enabled'
arch=('x86_64')
url='https://www.gnu.org/software/emacs/emacs.html'
license=('GPL-3.0-or-later')
depends=(
  alsa-lib
  gmp
  gnutls
  hicolor-icon-theme
  lcms2
  libacl.so
  libdbus-1.so
  libfontconfig.so
  libfreetype.so
  libgccjit
  libgdk-3.so
  libgdk_pixbuf-2.0.so
  libgif.so
  libgio-2.0.so
  libglib-2.0.so
  libgobject-2.0.so
  libgtk-3.so
  libharfbuzz.so
  libotf
  libpng
  libsystemd.so
  libtree-sitter.so
  libxml2.so
  sqlite
  webkit2gtk-4.1
  zlib
)
makedepends=(
  git
  gtk3
  libgccjit
  tree-sitter
  webkit2gtk-4.1
  texinfo
)
provides=('emacs')
conflicts=('emacs')
source=("emacs::git+https://github.com/emacs-mirror/emacs.git#branch=emacs-31")
b2sums=('SKIP')

pkgver() {
  cd "$srcdir/emacs"
  printf "31.1.r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

prepare() {
  cd "$srcdir/emacs"
  if [[ ! -x configure ]]; then
    ./autogen.sh
  fi
}

build() {
  local _confflags=(
    --sysconfdir=/etc
    --prefix=/usr
    --libexecdir=/usr/lib
    --localstatedir=/var
    --disable-build-details
    --with-pgtk
    --with-xwidgets
    --with-cairo
    --with-harfbuzz
    --with-libsystemd
    --with-modules
    --with-native-compilation=aot
    --with-tree-sitter
  )

  export ac_cv_lib_gif_EGifPutExtensionLast=yes

  cd "$srcdir/emacs"
  mkdir -p build-wayland-xwidgets
  cd build-wayland-xwidgets
  ../configure "${_confflags[@]}"
  make -j$(nproc)
}

package() {
  cd "$srcdir/emacs/build-wayland-xwidgets"
  make DESTDIR="${pkgdir}" install

  # fix user/root permissions on usr/share files
  chown -R root:root "${pkgdir}/usr/share/emacs"
}
