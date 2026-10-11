# emacs-wayland-pkg

Arch Linux PKGBUILD and automated build scripts for GNU Emacs (branch `emacs-31`) built with:
- **PGTK** (Pure GTK3 for native Wayland)
- **xwidgets** (WebKitGTK 4.1 in-buffer browser)
- **Native Compilation** (Ahead-of-Time via `libgccjit`)
- **Tree-sitter** (`libtree-sitter`)
- **Cairo & HarfBuzz**
- **SQLite3, WebP, SVG, Dynamic Modules, systemd user unit**

---

## Quick Start (Local Build)

```bash
# Clone this repository
git clone https://github.com/argrubbs/emacs-wayland-pkg.git
cd emacs-wayland-pkg

# Build and install package
./build.sh --install
```

### Script Options

* `./build.sh`: Builds the package.
* `./build.sh -i` / `--install`: Builds and installs using `sudo pacman -U`.
* `./build.sh -p` / `--pull`: Pulls the latest commits from upstream `emacs-31` before building.
* `./build.sh -c` / `--clean`: Cleans previous build artifacts for a fresh rebuild.

---

## GitHub Actions Automated Builds

A workflow ([`.github/workflows/build.yml`](.github/workflows/build.yml)) runs weekly on schedule or manually via workflow dispatch. It builds the package in an `archlinux:base-devel` container and publishes `.pkg.tar.zst` packages to GitHub Releases.

To install a pre-built release package directly from GitHub:

```bash
sudo pacman -U <release-asset-url>
```
