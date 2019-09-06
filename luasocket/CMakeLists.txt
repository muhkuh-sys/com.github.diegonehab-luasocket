cmake_minimum_required(VERSION 3.2.3)

PROJECT("luasocket")

INCLUDE(ExternalProject)
FIND_PACKAGE(PythonInterp 2.7 REQUIRED)

SET(VERSION_EXTERNAL "3.0.0")
SET(VERSION_PACKAGE  "2")
SET(PROJECT_VERSION  "${VERSION_EXTERNAL}.${VERSION_PACKAGE}")

# Get the VCS version for the jonchki configuration.
INCLUDE(${CMAKE_HOME_DIRECTORY}/cmake/version.cmake)

# Filter the jonchki configuration.
CONFIGURE_FILE(installer/lua${BUILDCFG_LUA_VERSION}/luasocket.xml
               ${CMAKE_CURRENT_BINARY_DIR}/lua${BUILDCFG_LUA_VERSION}-luasocket-${PROJECT_VERSION}.xml
               @ONLY)

#----------------------------------------------------------------------------
#
# Build the project.
#
OPTION(BUILDCFG_ONLY_JONCHKI_CFG "Build only the jonchki configuration. This is used for the resolve phase. The default is OFF."
       "OFF")

IF((BUILDCFG_ONLY_JONCHKI_CFG STREQUAL "OFF"))
	# Select the LUA version.
	INCLUDE(${CMAKE_HOME_DIRECTORY}/cmake/muhkuh_lua.cmake)

	SET(PRJ_CMAKE_ARGS "")
	LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}")
	LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")
	LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
	IF(CMAKE_SYSTEM_NAME STREQUAL "Windows")
		LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_RC_COMPILER=${CMAKE_RC_COMPILER}")
	ENDIF(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	LIST(APPEND PRJ_CMAKE_ARGS "-DLUA_LIBRARIES=${LUA_LIBRARIES}")
	LIST(APPEND PRJ_CMAKE_ARGS "-DLUA_INCLUDE_DIR=${LUA_INCLUDE_DIR}")
	LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=''")


	ExternalProject_Add(TARGET_luasocket
	                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/luasocket
	                    URL ${CMAKE_CURRENT_SOURCE_DIR}/luasocket-3.0-rc1.tar.gz
	                    URL_HASH SHA1=aff9122b26c01487c06a32133df78c1506af350f
	                    PATCH_COMMAND "${PYTHON_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/tools/apply_patches.py --working-folder ${CMAKE_CURRENT_BINARY_DIR}/luasocket/src/TARGET_luasocket --patch-folder ${CMAKE_CURRENT_SOURCE_DIR}/patches --strip 1 --copy-folder ${CMAKE_CURRENT_SOURCE_DIR}/copy_over
	                    CMAKE_ARGS ${PRJ_CMAKE_ARGS}
	                    TEST_COMMAND make test
	                    INSTALL_COMMAND make install DESTDIR=${CMAKE_BINARY_DIR}/install
	)

	#----------------------------------------------------------------------------
	#
	# Build a package for the selected platform.
	#

	SET(CPACK_OUTPUT_FILE_PREFIX ${CMAKE_BINARY_DIR}/../../repository/com/github/diegonehab/luasocket/${PROJECT_VERSION})
	SET(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)
	SET(CPACK_PACKAGE_FILE_NAME "lua${BUILDCFG_LUA_VERSION}-luasocket-${PROJECT_VERSION}-${JONCHKI_PLATFORM}")

	SET(CPACK_GENERATOR "TXZ")
	INCLUDE(CPack)

	# This is the folder where the external project TARGET_bitop installed the files.
	SET(SUB_INSTALL_DIR "${CMAKE_BINARY_DIR}/install")

	IF(JONCHKI_PLATFORM_DIST_ID STREQUAL "windows")
		# Package a windows build.

		# Install all files without execute permissions.
		INSTALL(FILES ${SUB_INSTALL_DIR}/lib/mime.core.dll
		        RENAME core.dll
		        DESTINATION lua_plugins/mime)
		INSTALL(FILES ${SUB_INSTALL_DIR}/lib/socket.core.dll
		        RENAME core.dll
		        DESTINATION lua_plugins/socket)
		INSTALL(DIRECTORY ${SUB_INSTALL_DIR}/lua
		        DESTINATION .)

		
		CONFIGURE_FILE(installer/lua${BUILDCFG_LUA_VERSION}/install_windows.lua
		               ${CMAKE_CURRENT_BINARY_DIR}/package/install.lua
		               @ONLY)

		INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/package/install.lua
		        DESTINATION .)
	ELSE(JONCHKI_PLATFORM_DIST_ID STREQUAL "windows")
		# Package a linux build.

		INSTALL(FILES ${SUB_INSTALL_DIR}/lib/mime.core.so
		        RENAME core.so
		        DESTINATION lua_plugins/mime)
		INSTALL(FILES ${SUB_INSTALL_DIR}/lib/socket.core.so
		        RENAME core.so
		        DESTINATION lua_plugins/socket)
		INSTALL(DIRECTORY ${SUB_INSTALL_DIR}/lua
		        DESTINATION .)

		CONFIGURE_FILE(installer/lua${BUILDCFG_LUA_VERSION}/install_linux.lua
		               ${CMAKE_CURRENT_BINARY_DIR}/package/install.lua
		               @ONLY)

		INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/package/install.lua
		        DESTINATION .)
	ENDIF(JONCHKI_PLATFORM_DIST_ID STREQUAL "windows")

	CONFIGURE_FILE(installer/lua${BUILDCFG_LUA_VERSION}/luasocket.xml
	               ${CPACK_OUTPUT_FILE_PREFIX}/lua${BUILDCFG_LUA_VERSION}-luasocket-${PROJECT_VERSION}-${JONCHKI_PLATFORM}.xml
	               @ONLY)


	#-----------------------------------------------------------------------------
	#
	# Create a custom target named "pack".
	# It builds the package and creates the hashes.
	#
	ADD_CUSTOM_TARGET(pack
	                  COMMAND ${CMAKE_MAKE_PROGRAM}
	                  COMMAND ${CMAKE_MAKE_PROGRAM} package
	                  COMMAND "${PYTHON_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/tools/generate_hash.py ${CPACK_OUTPUT_FILE_PREFIX}/lua${BUILDCFG_LUA_VERSION}-luasocket-${PROJECT_VERSION}-${JONCHKI_PLATFORM}.xml
	                  COMMAND "${PYTHON_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/tools/generate_hash.py ${CPACK_OUTPUT_FILE_PREFIX}/lua${BUILDCFG_LUA_VERSION}-luasocket-${PROJECT_VERSION}-${JONCHKI_PLATFORM}.tar.xz
	                  COMMENT "Pack the artifact and generate the hashes...")


	#-----------------------------------------------------------------------------
	#
	# Filter the pom.xml file.
	#
	SET(POM_ARTIFACT_ID  "lua${BUILDCFG_LUA_VERSION}-luasocket")
	SET(POM_GROUP_ID     "com.github.diegonehab")
	SET(POM_VERSION      "${PROJECT_VERSION}")
	SET(POM_PACKAGING    "tar.xz")
	CONFIGURE_FILE(installer/lua${BUILDCFG_LUA_VERSION}/pom.xml ${CPACK_OUTPUT_FILE_PREFIX}/lua${BUILDCFG_LUA_VERSION}-luasocket-${PROJECT_VERSION}.pom)
ENDIF((BUILDCFG_ONLY_JONCHKI_CFG STREQUAL "OFF"))
