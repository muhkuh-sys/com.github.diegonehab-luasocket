# Do not call this script directly. It is included from the .build??_*.sh files.

echo "PRJ_DIR        = ${PRJ_DIR}"
echo "BUILD_DIR      = ${BUILD_DIR}"
echo "CMAKE_COMPILER = ${CMAKE_COMPILER}"

# Create all folders.
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
mkdir ${BUILD_DIR}/lua5.1
mkdir ${BUILD_DIR}/lua5.1/build_requirements
mkdir ${BUILD_DIR}/lua5.2
mkdir ${BUILD_DIR}/lua5.2/build_requirements
mkdir ${BUILD_DIR}/lua5.3
mkdir ${BUILD_DIR}/lua5.3/build_requirements

# Install jonchki v0.0.1.1 .
python2.7 jonchki/jonchkihere.py --jonchki-version 0.0.1.1 ${BUILD_DIR}

# This is the path to the jonchki tool.
JONCHKI=${BUILD_DIR}/jonchki-0.0.1.1/jonchki

# Get the build requirements for the LUA5.1 version.
pushd ${BUILD_DIR}/lua5.1/build_requirements
cmake -DBUILDCFG_ONLY_JONCHKI_CFG="ON" -DBUILDCFG_LUA_VERSION="5.1" -DCMAKE_INSTALL_PREFIX="" ${CMAKE_COMPILER} ${PRJ_DIR}
make
${JONCHKI} --verbose debug --syscfg ${PRJ_DIR}/jonchki/jonchkisys.cfg --prjcfg ${PRJ_DIR}/jonchki/jonchkicfg.xml ${JONCHKI_SYSTEM} --build-dependencies luasocket/lua5.1-luasocket-*.xml
popd

# Build the LUA5.1 version.
pushd ${BUILD_DIR}/lua5.1
cmake -DBUILDCFG_LUA_USE_SYSTEM="OFF" -DBUILDCFG_LUA_VERSION="5.1" -DCMAKE_INSTALL_PREFIX="" ${CMAKE_COMPILER} ${PRJ_DIR}
make
popd


# Get the build requirements for the LUA5.2 version.
pushd ${BUILD_DIR}/lua5.2/build_requirements
cmake -DBUILDCFG_ONLY_JONCHKI_CFG="ON" -DBUILDCFG_LUA_VERSION="5.2" -DCMAKE_INSTALL_PREFIX="" ${CMAKE_COMPILER} ${PRJ_DIR}
make
${JONCHKI} --verbose debug --syscfg ${PRJ_DIR}/jonchki/jonchkisys.cfg --prjcfg ${PRJ_DIR}/jonchki/jonchkicfg.xml ${JONCHKI_SYSTEM} --build-dependencies luasocket/lua5.2-luasocket-*.xml
popd

# Build the LUA5.2 version.
pushd ${BUILD_DIR}/lua5.2
cmake -DBUILDCFG_LUA_USE_SYSTEM="OFF" -DBUILDCFG_LUA_VERSION="5.2" -DCMAKE_INSTALL_PREFIX="" ${CMAKE_COMPILER} ${PRJ_DIR}
make
popd


# Get the build requirements for the LUA5.3 version.
pushd ${BUILD_DIR}/lua5.3/build_requirements
cmake -DBUILDCFG_ONLY_JONCHKI_CFG="ON" -DBUILDCFG_LUA_VERSION="5.3" -DCMAKE_INSTALL_PREFIX="" ${CMAKE_COMPILER} ${PRJ_DIR}
make
${JONCHKI} --verbose debug --syscfg ${PRJ_DIR}/jonchki/jonchkisys.cfg --prjcfg ${PRJ_DIR}/jonchki/jonchkicfg.xml ${JONCHKI_SYSTEM} --build-dependencies luasocket/lua5.3-luasocket-*.xml
popd

# Build the LUA5.3 version.
pushd ${BUILD_DIR}/lua5.3
cmake -DBUILDCFG_LUA_USE_SYSTEM="OFF" -DBUILDCFG_LUA_VERSION="5.3" -DCMAKE_INSTALL_PREFIX="" ${CMAKE_COMPILER} ${PRJ_DIR}
make
popd