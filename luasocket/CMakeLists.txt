cmake_minimum_required(VERSION 3.2.3)

PROJECT("luasocket")

INCLUDE(ExternalProject)


#----------------------------------------------------------------------------
#
# Build the project.
#

SET(PRJ_CMAKE_ARGS "")
LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}")
LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")
LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_RC_COMPILER=${CMAKE_RC_COMPILER}")
ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
LIST(APPEND PRJ_CMAKE_ARGS "-DLUA_LIBRARIES=${LUA_LIBRARIES}")
LIST(APPEND PRJ_CMAKE_ARGS "-DLUA_INCLUDE_DIR=${LUA_INCLUDE_DIR}")
LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=''")


ExternalProject_Add(TARGET_luasocket
                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/luasocket-3.0-rc1
                    URL ${CMAKE_CURRENT_SOURCE_DIR}/luasocket-3.0-rc1.tar.gz
                    URL_HASH SHA1=aff9122b26c01487c06a32133df78c1506af350f
                    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/templates ${CMAKE_CURRENT_BINARY_DIR}/luasocket-3.0-rc1/src/TARGET_luasocket
                    CMAKE_ARGS ${PRJ_CMAKE_ARGS}
                    TEST_COMMAND make test
                    INSTALL_COMMAND make install DESTDIR=${CMAKE_CURRENT_BINARY_DIR}/rock
)


ADD_CUSTOM_COMMAND(TARGET TARGET_luasocket
                   POST_BUILD
                   COMMAND "${PYTHON_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/create_luarocks_manifest.py --verbose ${CMAKE_CURRENT_BINARY_DIR}/rock ${CMAKE_CURRENT_BINARY_DIR}/rock/rock_manifest)
