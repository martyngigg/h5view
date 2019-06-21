# ------------------------------------------------------------------------------
# Top-level compiler configuration script
#
# Performs a check for the required minimum version of the compiler and
# delegates the actual configuration to the appropriate file in the compilers
# subdirectory
# ------------------------------------------------------------------------------

# Required C++14 minimum. Conda compilers control themselves
if(NOT USE_CONDA)
  set(CMAKE_CXX_STANDARD 14)
  set(CMAKE_CXX_STANDARD_REQUIRED OFF)
endif()
set(CMAKE_CXX_EXTENSIONS OFF)

# Visibility hidden
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)

# GCC >= 4.2
if(
  CMAKE_CXX_COMPILER_ID STREQUAL "GNU"
  AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.2
)
  message(FATAL_ERROR "GCC 4.2 or later is required.")
else()
  include(Compilers/GNUConfig)
endif()
