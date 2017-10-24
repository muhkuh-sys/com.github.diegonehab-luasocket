CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

PROJECT("com.github.diegonehab-luasocket")

INCLUDE(../../../cmake/version.cmake)

SET(INSTALL_WIN32              "${CMAKE_CURRENT_SOURCE_DIR}/../../../build/lua5.1/windows_x86")
SET(INSTALL_WIN64              "${CMAKE_CURRENT_SOURCE_DIR}/../../../build/lua5.1/windows_x86_64")
SET(INSTALL_UBUNTU_1404_X86    "${CMAKE_CURRENT_SOURCE_DIR}/../../../build/lua5.1/ubuntu_1404_x86")
SET(INSTALL_UBUNTU_1404_X86_64 "${CMAKE_CURRENT_SOURCE_DIR}/../../../build/lua5.1/ubuntu_1404_x86_64")
SET(INSTALL_UBUNTU_1604_X86    "${CMAKE_CURRENT_SOURCE_DIR}/../../../build/lua5.1/ubuntu_1604_x86")
SET(INSTALL_UBUNTU_1604_X86_64 "${CMAKE_CURRENT_SOURCE_DIR}/../../../build/lua5.1/ubuntu_1604_x86_64")
SET(INSTALL_UBUNTU_1704_X86    "${CMAKE_CURRENT_SOURCE_DIR}/../../../build/lua5.1/ubuntu_1704_x86")
SET(INSTALL_UBUNTU_1704_X86_64 "${CMAKE_CURRENT_SOURCE_DIR}/../../../build/lua5.1/ubuntu_1704_x86_64")

# Get the project version. All folders have the same version file.
INCLUDE(${INSTALL_WIN32}/com.github.diegonehab-luasocket.version)
SET(PROJECT_VERSION ${com.github.diegonehab-luasocket_VERSION})

SET(CPACK_OUTPUT_FILE_PREFIX targets/jonchki/repository/com/github/diegonehab/luasocket/${PROJECT_VERSION})
SET(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)
SET(CPACK_PACKAGE_FILE_NAME "lua5.1-luasocket-${PROJECT_VERSION}")

SET(CPACK_GENERATOR "TXZ")
INCLUDE(CPack)


#-----------------------------------------------------------------------------
#
# Install the 32bit files.
#
INSTALL(FILES ${INSTALL_WIN32}/lib/mime.core.dll
        DESTINATION windows_x86/lua_plugins/mime/
        RENAME core.dll)
INSTALL(FILES ${INSTALL_WIN32}/lib/socket.core.dll
        DESTINATION windows_x86/lua_plugins/socket/
        RENAME core.dll)
INSTALL(DIRECTORY ${INSTALL_WIN32}/lua/
        DESTINATION windows_x86/lua/)

INSTALL(FILES ${INSTALL_UBUNTU_1404_X86}/lib/mime.core.so
        DESTINATION windows_x86/lua_plugins/mime/
        RENAME core.so)
INSTALL(FILES ${INSTALL_UBUNTU_1404_X86}/lib/socket.core.so
        DESTINATION windows_x86/lua_plugins/socket/
        RENAME core.so)
INSTALL(DIRECTORY ${INSTALL_UBUNTU_1404_X86}/lua/
        DESTINATION windows_x86/lua/)

INSTALL(FILES ${INSTALL_UBUNTU_1604_X86}/lib/mime.core.so
        DESTINATION windows_x86/lua_plugins/mime/
        RENAME core.so)
INSTALL(FILES ${INSTALL_UBUNTU_1604_X86}/lib/socket.core.so
        DESTINATION windows_x86/lua_plugins/socket/
        RENAME core.so)
INSTALL(DIRECTORY ${INSTALL_UBUNTU_1604_X86}/lua/
        DESTINATION windows_x86/lua/)

INSTALL(FILES ${INSTALL_UBUNTU_1704_X86}/lib/mime.core.so
        DESTINATION windows_x86/lua_plugins/mime/
        RENAME core.so)
INSTALL(FILES ${INSTALL_UBUNTU_1704_X86}/lib/socket.core.so
        DESTINATION windows_x86/lua_plugins/socket/
        RENAME core.so)
INSTALL(DIRECTORY ${INSTALL_UBUNTU_1704_X86}/lua/
        DESTINATION windows_x86/lua/)


#-----------------------------------------------------------------------------
#
# Install the 64bit files.
#
INSTALL(FILES ${INSTALL_WIN64}/lib/mime.core.dll
        DESTINATION windows_x86_64/lua_plugins/mime/
        RENAME core.dll)
INSTALL(FILES ${INSTALL_WIN64}/lib/socket.core.dll
        DESTINATION windows_x86_64/lua_plugins/socket/
        RENAME core.dll)
INSTALL(DIRECTORY ${INSTALL_WIN64}/lua/
        DESTINATION windows_x86_64/lua/)

INSTALL(FILES ${INSTALL_UBUNTU_1404_X86_64}/lib/mime.core.so
        DESTINATION windows_x86_64/lua_plugins/mime/
        RENAME core.so)
INSTALL(FILES ${INSTALL_UBUNTU_1404_X86_64}/lib/socket.core.so
        DESTINATION windows_x86_64/lua_plugins/socket/
        RENAME core.so)
INSTALL(DIRECTORY ${INSTALL_UBUNTU_1404_X86_64}/lua/
        DESTINATION windows_x86_64/lua/)

INSTALL(FILES ${INSTALL_UBUNTU_1604_X86_64}/lib/mime.core.so
        DESTINATION windows_x86_64/lua_plugins/mime/
        RENAME core.so)
INSTALL(FILES ${INSTALL_UBUNTU_1604_X86_64}/lib/socket.core.so
        DESTINATION windows_x86_64/lua_plugins/socket/
        RENAME core.so)
INSTALL(DIRECTORY ${INSTALL_UBUNTU_1604_X86_64}/lua/
        DESTINATION windows_x86_64/lua/)

INSTALL(FILES ${INSTALL_UBUNTU_1704_X86_64}/lib/mime.core.so
        DESTINATION windows_x86_64/lua_plugins/mime/
        RENAME core.so)
INSTALL(FILES ${INSTALL_UBUNTU_1704_X86_64}/lib/socket.core.so
        DESTINATION windows_x86_64/lua_plugins/socket/
        RENAME core.so)
INSTALL(DIRECTORY ${INSTALL_UBUNTU_1704_X86_64}/lua/
        DESTINATION windows_x86_64/lua/)


#-----------------------------------------------------------------------------

INSTALL(FILES install.lua
        DESTINATION .)


CONFIGURE_FILE(luasocket.xml
               ${CPACK_OUTPUT_FILE_PREFIX}/lua5.1-luasocket-${PROJECT_VERSION}.xml
               @ONLY)

#-----------------------------------------------------------------------------
#
# Filter the pom.xml file.
#
SET(POM_ARTIFACT_ID  "lua5.1-luasocket")
SET(POM_GROUP_ID     "com.github.diegonehab")
SET(POM_VERSION      "${PROJECT_VERSION}")
SET(POM_PACKAGING    "tar.xz")
CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/pom.xml ${CPACK_OUTPUT_FILE_PREFIX}/lua5.1-luasocket-${PROJECT_VERSION}.pom)
