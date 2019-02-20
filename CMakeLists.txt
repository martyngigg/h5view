cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

foreach(p
    CMP0020 # Automatically link Qt executables to qtmain target on Windows.
    CMP0022 # INTERFACE_LINK_LIBRARIES defines the link interface.
    CMP0025 # Compiler id for Apple Clang is now AppleClang.
    CMP0053 # Simplify variable reference and escape sequence evaluation.
    CMP0054 # Only interpret if() arguments as variables or keywords when unquoted.
    )
  if(POLICY ${p})
    cmake_policy(SET ${p} NEW)
  endif()
endforeach()

project(
  project_name
  VERSION 0.0.0.0
)

# Project-cmake files
set(project_name_CMAKE_DIR "${project_name_SOURCE_DIR}/cmake/Modules")
set(CMAKE_MODULE_PATH ${project_name_CMAKE_DIR} ${CMAKE_MODULE_PATH})

# Set up our directory structure for output libraries and binaries
if(NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${project_name_BINARY_DIR}/bin")
endif()
if(NOT CMAKE_LIBRARY_OUTPUT_DIRECTORY)
  if(UNIX)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${project_name_BINARY_DIR}/lib")
  else()
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${project_name_BINARY_DIR}/bin")
  endif()
endif()
if(NOT CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${project_name_BINARY_DIR}/lib")
endif()
mark_as_advanced(CMAKE_RUNTIME_OUTPUT_DIRECTORY
  CMAKE_LIBRARY_OUTPUT_DIRECTORY
  CMAKE_ARCHIVE_OUTPUT_DIRECTORY
  )

include (DefineVersion)

# ------------------------------------------------------------------------------
# Compilers
# ------------------------------------------------------------------------------
include (ConfigureCompiler)

# ------------------------------------------------------------------------------
# Testing - must be before any targets are added
# ------------------------------------------------------------------------------
option (ENABLE_TESTING "Enable testing modules" ON)
if (ENABLE_TESTING)
  enable_testing ()
  include (EnableCxxTestingMacros)
endif ()

# ------------------------------------------------------------------------------
# Sources
# ------------------------------------------------------------------------------

# ...add_subdirectory() commands etc

# ------------------------------------------------------------------------------
# Static checks
# ------------------------------------------------------------------------------
add_subdirectory (devtools/static-analysis/cppcheck)

# ------------------------------------------------------------------------------
# Documentation
# ------------------------------------------------------------------------------
add_subdirectory (docs/developer/doxygen)
