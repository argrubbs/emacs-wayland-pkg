#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EMACS_DIR="${EMACS_DIR:-/home/adam/dev/emacs}"

DO_PULL=false
DO_INSTALL=false
DO_CLEAN=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Builds Emacs with PGTK and xwidgets as an Arch Linux package.

Options:
  -i, --install   Install the package with 'sudo pacman -U' after building
  -p, --pull      Pull latest commits from origin/emacs-31 before building
  -c, --clean     Clean previous build directory before rebuilding
  -h, --help      Show this help message
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--install) DO_INSTALL=true; shift ;;
    -p|--pull)    DO_PULL=true; shift ;;
    -c|--clean)   DO_CLEAN=true; shift ;;
    -h|--help)    usage ;;
    *) echo "Unknown option: $1" >&2; usage ;;
  esac
done

cd "$SCRIPT_DIR"

if [ -d "$EMACS_DIR/.git" ]; then
  if [ "$DO_PULL" = true ]; then
    echo "==> Pulling latest changes in $EMACS_DIR..."
    git -C "$EMACS_DIR" pull --ff-only
  fi

  if [ "$DO_CLEAN" = true ]; then
    echo "==> Cleaning build directory in $EMACS_DIR/build-wayland-xwidgets..."
    rm -rf "$EMACS_DIR/build-wayland-xwidgets"
  fi

  mkdir -p src
  ln -sfn "$EMACS_DIR" src/emacs
  echo "==> Building using local source: $EMACS_DIR..."
  makepkg -e -f --noconfirm
else
  echo "==> Building using makepkg git source..."
  makepkg -s -f --noconfirm
fi

PKG_FILE="$(ls -t "$SCRIPT_DIR"/emacs-wayland-*.pkg.tar.zst 2>/dev/null | grep -v 'debug' | head -n 1)"

echo "==> Successfully built: $PKG_FILE"

if [ "$DO_INSTALL" = true ]; then
  echo "==> Installing package via pacman..."
  sudo pacman -U --noconfirm "$PKG_FILE"
  echo "==> Emacs installation complete!"
else
  echo ""
  echo "To install, run:"
  echo "  sudo pacman -U $PKG_FILE"
  echo "Or re-run this script with -i / --install"
fi
