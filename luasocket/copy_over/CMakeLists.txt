# Copyright (C) 2007-2013 LuaDist.
# Created by Peter Drahoš, David Manura
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
# Please note that the package source code is licensed under its own license.

project ( luasocket C )
cmake_minimum_required ( VERSION 2.8 )
#include ( cmake/dist.cmake )
#include ( lua )

ENABLE_TESTING()
FIND_PACKAGE(PythonInterp 2.7 REQUIRED)


# Configuration
option ( LUASOCKET_UNIX "Use only unix domain features." OFF )

# Activate the compatibility functions for LUA5.3.
ADD_DEFINITIONS(-DLUA_COMPAT_5_2)

# The standard luasocket build has this enabled in release mode.
# It is required for running the test suite.
add_definitions ( -DLUASOCKET_DEBUG )
if ( MINGW )
	add_definitions ( -DLUASOCKET_INET_PTON -D_WIN32_WINNT=0x501 )
endif ( )

# Shared library exporting.
if ( WIN32 )
  add_definitions ( "-DMIME_API=__declspec(dllexport)" "-DLUASOCKET_API=__declspec(dllexport)" )
endif ( )

if ( WIN32 AND NOT CYGWIN )
  set ( SOCKETC src/wsocket.c )
else ( )
  set ( SOCKETC src/usocket.c )
endif ( )

set ( SRC_SOCKET src/luasocket.c src/timeout.c src/buffer.c src/io.c src/auxiliar.c 
  src/options.c src/inet.c src/tcp.c src/udp.c src/except.c src/select.c ${SOCKETC} )
  
set ( UNIX_SOCKET src/unix.c src/io.c src/auxiliar.c src/timeout.c src/options.c
  src/buffer.c ${SOCKETC} )

if ( WIN32 AND NOT CYGWIN )
  set ( LIB_SOCKET ws2_32 )
endif ()

# Solaris needs specific links
if ( CMAKE_SYSTEM_NAME STREQUAL "SunOS" )
	set ( LIB_SOCKET socket resolv rt )
endif ( )

# Binary
ADD_LIBRARY(TARGET_socket_core MODULE
            ${SRC_SOCKET})
TARGET_INCLUDE_DIRECTORIES(TARGET_socket_core
                           PRIVATE ${LUA_INCLUDE_DIR})
TARGET_LINK_LIBRARIES(TARGET_socket_core ${LUA_LIBRARIES} ${LIB_SOCKET})
SET_TARGET_PROPERTIES(TARGET_socket_core PROPERTIES PREFIX "" OUTPUT_NAME "socket.core")

ADD_LIBRARY(TARGET_mime_core MODULE
            src/mime.c)
TARGET_INCLUDE_DIRECTORIES(TARGET_mime_core
                           PRIVATE ${LUA_INCLUDE_DIR})
TARGET_LINK_LIBRARIES(TARGET_mime_core ${LUA_LIBRARIES})
SET_TARGET_PROPERTIES(TARGET_mime_core PROPERTIES PREFIX "" OUTPUT_NAME "mime.core")

INSTALL(TARGETS TARGET_socket_core TARGET_mime_core
        EXPORT EXPORT_package
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION bin
        INCLUDES DESTINATION include)

# Lua
INSTALL(FILES src/ltn12.lua src/mime.lua src/socket.lua
        DESTINATION lua)
INSTALL(FILES src/ftp.lua src/http.lua src/smtp.lua src/tp.lua src/url.lua src/headers.lua
        DESTINATION lua/socket)

#if ( LUASOCKET_UNIX )
#  install_lua_module ( socket.unix ${UNIX_SOCKET} LINK ${LIB_SOCKET} )
#endif ()

#install_foo ( etc/ )
#install_test ( test/ )
#install_example ( samples/ )
#install_doc ( doc/ )
#install_data ( README NEW LICENSE )


# Add tests for this module.
IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
	# Here are the MinGW specific tests.
	ADD_TEST(NAME luafilesystem_MinGW_DLL_dependencies
	         COMMAND "${PYTHON_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/tests/mingw_dll_dependencies.py -u lua5.1 -u lua5.2 -u lua5.3 -u lua5.4 $<TARGET_FILE:TARGET_socket_core> $<TARGET_FILE:TARGET_mime_core>)
ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))

