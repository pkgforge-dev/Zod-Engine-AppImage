#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor     \
    sdl12-compat \
    sdl_image    \
    sdl_mixer    \
    sdl_ttf

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package gconf
make-aur-package gtk2
#make-aur-package libvisual
#make-aur-package gstreamer0.10
#make-aur-package gstreamer0.10-base
#make-aur-package gstreamer0.10-base-plugins
make-aur-package wxgtk2.8-light
make-aur-package libmysqlclient

# If the application needs to be manually built that has to be done down here
echo "Getting Zod Engine binary..."
echo "---------------------------------------------------------------"
VERSION=2011-09-06
echo "$VERSION" > ~/version
wget https://master.dl.sourceforge.net/project/zod/linux_releases/zod_linux-${VERSION}.tar.gz

mkdir -p ./AppDir/bin
bsdtar -xvf zod_linux-${VERSION}.tar.gz -C ./AppDir/bin --strip-components=1
rm -rf ./AppDir/bin/zod_launcher_src
rm -rf ./AppDir/bin/zod_src
