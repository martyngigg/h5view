cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

foreach(p
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

project(editor VERSION 0.0.0.1)

# Project-cmake files
set(editor_CMAKE_DIR "${editor_SOURCE_DIR}/cmake/Modules")
set(CMAKE_MODULE_PATH ${editor_CMAKE_DIR} ${CMAKE_MODULE_PATH})

# Set up our directory structure for output libraries and binaries
if(NOT CMAKE_RUNTIME_OUTPUT_DIRECTORY)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${editor_BINARY_DIR}/bin")
endif()
if(NOT CMAKE_LIBRARY_OUTPUT_DIRECTORY)
  if(UNIX)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${editor_BINARY_DIR}/lib")
  else()
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${editor_BINARY_DIR}/bin")
  endif()
endif()
if(NOT CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${editor_BINARY_DIR}/lib")
endif()
mark_as_advanced(CMAKE_RUNTIME_OUTPUT_DIRECTORY CMAKE_LIBRARY_OUTPUT_DIRECTORY
                 CMAKE_ARCHIVE_OUTPUT_DIRECTORY)

# ------------------------------------------------------------------------------
# Compilers
# ------------------------------------------------------------------------------
include(CompilerConfig)

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
add_subdirectory(applications)
