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

project(h5view VERSION 0.1.0 LANGUAGES CXX)

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
mark_as_advanced(CMAKE_RUNTIME_OUTPUT_DIRECTORY CMAKE_LIBRARY_OUTPUT_DIRECTORY
                 CMAKE_ARCHIVE_OUTPUT_DIRECTORY)

# ------------------------------------------------------------------------------
# Compilers
# ------------------------------------------------------------------------------
include(CompilerConfig)

# ------------------------------------------------------------------------------
# Dependencies
# ------------------------------------------------------------------------------
if(NOT EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
  message(
    FATAL_ERROR
      "Unable to find ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake."
      "Have you run 'conan install ...'?"
  )
endif()
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup(TARGETS KEEP_RPATHS)

# ------------------------------------------------------------------------------
# Static checks
# ------------------------------------------------------------------------------
include(CppCheck)

# ------------------------------------------------------------------------------
# Testing
# ------------------------------------------------------------------------------
option(ENABLE_TESTING "If enabled add tests to ctest targets" ON)
option(ENABLE_COVERAGE "If enabled add coverage reporting" OFF)
if(ENABLE_TESTING)
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  add_subdirectory(external/googletest)
  mark_as_advanced(
    BUILD_GMOCK BUILD_GTEST BUILD_SHARED_LIBS
    gmock_build_tests gtest_build_samples gtest_build_tests
    gtest_disable_pthreads gtest_force_shared_crt gtest_hide_internal_symbols
  )
  set_target_properties(gtest PROPERTIES FOLDER extern)
  set_target_properties(gtest_main PROPERTIES FOLDER extern)
  set_target_properties(gmock PROPERTIES FOLDER extern)
  set_target_properties(gmock_main PROPERTIES FOLDER extern)
  include(GoogleTest)
  enable_testing()
  if(ENABLE_COVERAGE)
    set(COVERAGE_CFLAGS -fprofile-arcs -ftest-coverage)
    set(COVERAGE_LFLAGS -lgcov --coverage)
  endif()
endif()

# ------------------------------------------------------------------------------
# Targets
# ------------------------------------------------------------------------------
# Setup default RPATH for installed targets
set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")

# Process sources
add_subdirectory(src)

# ------------------------------------------------------------------------------
# Packaging
# ------------------------------------------------------------------------------
option(ENABLE_CPACK "If true, enable package rules to be generated.
                     Currently on supports Debian" OFF)
if(ENABLE_CPACK)
  # Install any runtime libraries required
  include(InstallRequiredSystemLibraries)

  # Bundle conan dependencies
  install(
    CODE
      "
      execute_process(COMMAND
                        conan imports
                          -imf \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX} ${CMAKE_SOURCE_DIR}
                      RESULT_VARIABLE conan_result
                      OUTPUT_VARIABLE _out ERROR_VARIABLE _out)
      if(NOT conan_result EQUAL 0)
        message(\"\${_out}\")
        message(FATAL_ERROR \"Package script failed!!!\\n\")
      endif()
    "
  )

  set(CPACK_PACKAGE_VERSION_MAJOR "${h5view_VERSION_MAJOR}")
  set(CPACK_PACKAGE_VERSION_MINOR "${h5view_VERSION_MINOR}")
  set(CPACK_PACKAGING_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})

  # create a package for the platform if not generate a source tarball
  if(EXISTS /etc/debian_version) # debian-like
    set(CPACK_GENERATOR DEB)
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER martyngigg)
    set(CPACK_DEBIAN_PACKAGE_DEPENDS "")
  elseif(EXISTS /etc/redhat-release) # redhat-like
    set(CPACK_GENERATOR RPM)
    set(CPACK_RPM_PACKAGE_REQUIRES "")
    set(CPACK_SYSTEM_NAME amd64)
  endif()

  include(CPack)
endif()
