#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    gtk3             \
    libdecor         \
    mariadb-libs     \
    mercurial        \
    openmp           \
    sdl12-compat     \
    sdl_image        \
    sdl_mixer        \
    sdl_ttf          \
    wxwidgets-common \
    wxwidgets-gtk3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here
echo "Getting Zod Engine binary..."
echo "---------------------------------------------------------------"
VERSION=2011-09-06
echo "$VERSION" > ~/version
wget https://master.dl.sourceforge.net/project/zod/linux_releases/zod_linux-${VERSION}.tar.gz
hg clone http://hg.code.sf.net/p/zod/zod_engine zod_engine

mkdir -p ./AppDir/bin
cd zod_engine/src
sed -i '1i #include <ctime>' common.cpp
make -j$(nproc)
mv -v zod ../../AppDir/bin
cd ..
mv -v assets blank_maps ../AppDir/bin
find . -maxdepth 1 -type f \( -name "*.map" -o -name "*.txt" \) -exec mv -t ../AppDir/bin/ {} +
cd .. && rm -rf zod_engine

mkdir -p ./zodsrc
bsdtar -xvf zod_linux-${VERSION}.tar.gz -C ./zodsrc --strip-components=1
cd ./zodsrc/zod_launcher_src
sed -i "s/check.replace(i,1,1,'_');/check.replace(i,1,1, (wxUniChar)'_');/g" zod_launcherFrm.cpp
make -j$(nproc)
mv -v zod_launcher ../../AppDir/bin
