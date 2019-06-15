cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

foreach(
  p
  CMP0020 # Automatically link Qt executables to qtmain target on Windows.
  CMP0022 # INTERFACE_LINK_LIBRARIES defines the link interface.
  CMP0025 # Compiler id for Apple Clang is now AppleClang.
  CMP0053 # Simplify variable reference and escape sequence evaluation.
  CMP0054 # Only interpret if() arguments as variables or keywords when
          # unquoted.
)
  if(POLICY ${p})
    cmake_policy(SET ${p} NEW)
  endif()
endforeach()

project(h5view VERSION 0.0.0.1 LANGUAGES CXX)

# Project-cmake files
set(h5view_CMAKE_DIR "${h5view_SOURCE_DIR}/cmake/Modules")
set(CMAKE_MODULE_PATH ${h5view_CMAKE_DIR} ${CMAKE_MODULE_PATH})

# Set up our directory structure for output libraries and binaries
if(NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${h5view_BINARY_DIR}/bin")
endif()
if(NOT CMAKE_LIBRARY_OUTPUT_DIRECTORY)
  if(UNIX)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${h5view_BINARY_DIR}/lib")
  else()
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${h5view_BINARY_DIR}/bin")
  endif()
endif()
if(NOT CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${h5view_BINARY_DIR}/lib")
endif()
mark_as_advanced(
  CMAKE_RUNTIME_OUTPUT_DIRECTORY CMAKE_LIBRARY_OUTPUT_DIRECTORY
  CMAKE_ARCHIVE_OUTPUT_DIRECTORY
)

# ------------------------------------------------------------------------------
# Compilers
# ------------------------------------------------------------------------------
include(CompilerConfig)

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------
option(USE_CONAN "Use conan for all dependencies" OFF)
option(USE_CONDA "Use conda for all dependencies" OFF)
if(USE_CONAN)
  if(NOT EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
      message(FATAL_ERROR "Unable to find ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake. Have you run 'conan install ...'?")
  endif()
  include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
  conan_basic_setup()
elseif(USE_CONDA)
  # does it look like we are in a conda environment
  if(NOT DEFINED ENV{CONDA_PREFIX})
    message(FATAL_ERROR "CONDA_PREFIX env variable not defined. Has a conda environment been defined?")
  endif()
  # set variables to help cmake find packages
  set(CMAKE_PREFIX_PATH $ENV{CONDA_PREFIX})

  find_package(HDF5 COMPONENTS CXX REQUIRED)
else()
  message(FATAL_ERROR "Must use either conda or conan for dependencies")
endif()

# ------------------------------------------------------------------------------
# Static checks
# ------------------------------------------------------------------------------
include(CppCheck)

# ------------------------------------------------------------------------------
# Testing
# ------------------------------------------------------------------------------
option(ENABLE_TESTING "If enabled add tests to ctest targets" ON)
if(ENABLE_TESTING)
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  # googlemock includes googlemock test targets
  add_subdirectory(external/googletest/googlemock)
  enable_testing()
endif()

# ------------------------------------------------------------------------------
# Sources
# ------------------------------------------------------------------------------
add_subdirectory(src)
