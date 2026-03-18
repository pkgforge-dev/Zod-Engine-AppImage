#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
tee -a /etc/pacman.conf <<EOF

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
pacman -Syu --noconfirm \
    cmake          \
    gcc-libs       \
    lib32-gcc-libs \
    libdecor       \
    openmp         \
    sdl12-compat   \
    sdl_image      \
    sdl_mixer      \
    sdl_ttf

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package gtk2
make-aur-package wxwidgets2.8-light
make-aur-package libmysqlclient

# If the application needs to be manually built that has to be done down here
echo "Getting Zod Engine binary..."
echo "---------------------------------------------------------------"
VERSION=2011-09-06
echo "$VERSION" > ~/version
wget https://master.dl.sourceforge.net/project/zod/linux_releases/zod_linux-${VERSION}.tar.gz
https://sourceforge.net/code-snapshots/hg/u/u/u/digitalus/zod/u-digitalus-zod-fbbd44b71cf36b8567512e67a72ba38a6b35141f.zip

mkdir -p ./AppDir/bin
mkdir -p ./zodsrc
tar -xvf u-digitalus-zod-fbbd44b71cf36b8567512e67a72ba38a6b35141f.zip -C ./zodsrc --strip-components=1
cd zodsrc
mkdir build && cd build
cmake  .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
mv -v zod_map_editor zod ../../AppDir/bin
mv -v ../game/* ../../AppDir
cd ../.. && rm -rf zodsrc
mkdir -p ./zodsrc

bsdtar -xvf zod_linux-${VERSION}.tar.gz -C ./zodsrc --strip-components=1
cd ./zodsrc/zod_launcher_src
sed -i "s/check.replace(i,1,1,'_');/check.replace(i,1,1, (wxUniChar)'_');/g" zod_launcherFrm.cpp
make -j$(nproc)
mv -v zod_launcher ../../AppDir/bin
