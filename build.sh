#! /bin/bash
set -e

export CC=gcc-10
export CXX=g++-10

cd /opt/
wget http://cern.ch/geant4-data/releases/$G4.tar.gz --no-check-certificate
tar xf $G4.tar.gz

# Workaround: Remove deb-destroying symlink in G4ConfigureGNUMakeHelpers
# Note: patch contains fixes for different versions, not all hunks will apply, 1 fail is expected
patch $G4/cmake/Modules/G4ConfigureGNUMakeHelpers.cmake < /io/patch-symlinks.diff || true

mkdir $G4-build
cd $G4-build

# Workaround: Explicitly set CMAKE_INSTALL_PREFIX=/usr/ and CMAKE_INSTALL_LIBDIR=lib/
# to get around some weird shenanigans where Geant4 messes with the lib directories
cmake ../$G4 \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_STATIC_LIBS=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/ \
    -DCMAKE_INSTALL_LIBDIR=lib/ \
    -DGEANT4_BUILD_BUILTIN_BACKTRACE=OFF \
    -DGEANT4_BUILD_CXXSTD=17 \
    -DGEANT4_BUILD_MULTITHREADED=ON \
    -DGEANT4_BUILD_PHP_AS_HP=OFF \
    -DGEANT4_BUILD_STORE_TRAJECTORY=ON \
    -DGEANT4_BUILD_TLS_MODEL=global-dynamic \
    -DGEANT4_BUILD_VERBOSE_CODE=OFF \
    -DGEANT4_ENABLE_TESTING=OFF \
    -DGEANT4_INSTALL_DATA=ON \
    -DGEANT4_INSTALL_DATA_TIMEOUT=1500 \
    -DGEANT4_INSTALL_DATASETS_TENDL=OFF \
    -DGEANT4_INSTALL_EXAMPLES=OFF \
    -DGEANT4_INSTALL_PACKAGE_CACHE=OFF \
    -DGEANT4_USE_FREETYPE=OFF \
    -DGEANT4_USE_G3TOG4=OFF \
    -DGEANT4_USE_GDML=ON \
    -DGEANT4_USE_HDF5=OFF \
    -DGEANT4_USE_INVENTOR=OFF \
    -DGEANT4_USE_INVENTOR_QT=OFF \
    -DGEANT4_USE_NETWORKDAWN=OFF \
    -DGEANT4_USE_NETWORKVRML=OFF \
    -DGEANT4_USE_OPENGL_X11=OFF \
    -DGEANT4_USE_PYTHON=ON \
    -DGEANT4_USE_QT=OFF \
    -DGEANT4_USE_RAYTRACER_X11=OFF \
    -DGEANT4_USE_SMARTSTACK=OFF \
    -DGEANT4_USE_SYSTEM_CLHEP=OFF \
    -DGEANT4_USE_SYSTEM_CLHEP_GRANULAR=OFF \
    -DGEANT4_USE_SYSTEM_EXPAT=ON \
    -DGEANT4_USE_SYSTEM_PTL=OFF \
    -DGEANT4_USE_SYSTEM_ZLIB=OFF \
    -DGEANT4_USE_TBB=OFF \
    -DGEANT4_USE_TIMEMORY=OFF \
    -DGEANT4_USE_USOLIDS=OFF \
    -DGEANT4_USE_XM=OFF \
    -DPYTHON_EXECUTABLE=/usr/bin/python3.9 \
    -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.9.so \
    -DPYTHON_INCLUDE_DIR=/usr/include/python3.9/

cmake --build . --parallel $(nproc)

cpack -G DEB \
    -D CPACK_DEBIAN_PACKAGE_MAINTAINER="Jan Mayer <jan.mayer@ikp.uni-koeln.de>" \
    -D CPACK_DEBIAN_PACKAGE_DEPENDS="libxerces-c-dev, libexpat-dev" \
    -D CPACK_DEBIAN_PACKAGE_RECOMMENDS="libboost-python-dev, python3.9-dev" \
    -D CPACK_DEBIAN_COMPRESSION_TYPE="xz" \
    -D CPACK_THREADS=$(nproc)

dpkg-name *.deb

mv *.deb /io/
