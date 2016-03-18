# ------------------------------------------------------------------------------
# Configuration options for GCC
# ------------------------------------------------------------------------------
set (GCC_COMPILER_VERSION ${CMAKE_CXX_COMPILER_VERSION} CACHE INTERNAL "")
message (STATUS "gcc version: ${GCC_COMPILER_VERSION}")

# Addtional warnings for GCC
set (CMAKE_CXX_FLAGS_WARN "-Wnon-virtual-dtor -Wno-long-long -ansi -Wcast-align -Wchar-subscripts -Wall -Wextra -Wpointer-arith -Wformat-security -Woverloaded-virtual -Wshadow -Wunused-parameter -fno-check-new -fno-common")

include (CheckCXXCompilerFlag)

check_cxx_compiler_flag ("-std=c++14" COMPILER_SUPPORTS_CXX14 )
check_cxx_compiler_flag ("-std=c++11" COMPILER_SUPPORTS_CXX11 )
check_cxx_compiler_flag ("-std=c++0x" COMPILER_SUPPORTS_CXX0X )
if (COMPILER_SUPPORTS_CXX14)
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
elseif (COMPILER_SUPPORTS_CXX11)
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif (COMPILER_SUPPORTS_CXX0X)
  set (CMAKE_CXX_FLAGS "$${CMAKE_CXX_FLAGS} -std=c++0x")
endif()

# This flag is useful as not returning from a non-void function is an error
# with MSVC, but it is not supported on all GCC compiler versions
check_cxx_compiler_flag (-Werror=return-type HAVE_GCC_ERROR_RETURN_TYPE)
if(HAVE_GCC_ERROR_RETURN_TYPE)
  set (CMAKE_CXX_FLAGS_ERROR "-Werror=return-type")
endif()

# Gcc visibility support
check_cxx_compiler_flag (-fvisibility=hidden HAVE_GCC_VISIBILITY)
if (HAVE_GCC_ERROR_RETURN_TYPE)
  set (CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fvisibility=hidden -fvisibility-inlines-hidden")
endif ()

# Set extra warning flags in debug modes
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO
  "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${CMAKE_CXX_FLAGS_WARN}")
set(CMAKE_CXX_FLAGS_DEBUG
  "${CMAKE_CXX_FLAGS_DEBUG} ${CMAKE_CXX_FLAGS_WARN} ${CMAKE_CXX_FLAGS_ERROR}")
