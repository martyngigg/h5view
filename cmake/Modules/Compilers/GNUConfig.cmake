# ------------------------------------------------------------------------------
# Configuration options for GCC
# ------------------------------------------------------------------------------
set(GCC_COMPILER_VERSION ${CMAKE_CXX_COMPILER_VERSION} CACHE INTERNAL "")
message(STATUS "gcc version: ${GCC_COMPILER_VERSION}")

# Addtional warnings for GCC
set(CMAKE_CXX_FLAGS_WARN "\
-Wnon-virtual-dtor \
-Wcast-align \
-Wchar-subscripts \
-Wall \
-Wextra \
-Wpointer-arith \
-Wformat-security \
-Woverloaded-virtual \
-Wshadow \
-Wunused-parameter \
-fno-check-new \
-fno-common")

include(CheckCXXCompilerFlag)

# This flag is useful as not returning from a non-void function is an error with
# MSVC, but it is not supported on all GCC compiler versions
check_cxx_compiler_flag(-Werror=return-type HAVE_GCC_ERROR_RETURN_TYPE)
if(HAVE_GCC_ERROR_RETURN_TYPE)
  set(CMAKE_CXX_FLAGS_ERROR "-Werror=return-type")
endif()

# Sanitizers
option(ENABLE_SANITIZERS
       "Enable address and leak sanitizers for debug builds" ON)
if(ENABLE_SANITIZERS)
  set(
    SANITIZER_FLAGS
    "-fsanitize=address,leak -fno-omit-frame-pointer"
  )
else()
  set(SANITIZER_FLAGS "")
endif()

# Clang-tidy
option(ENABLE_CLANG_TIDY "Add clang-tidy automatically to builds" OFF)
if(ENABLE_CLANG_TIDY)
  find_program(CLANG_TIDY_EXE NAMES "clang-tidy" PATHS /usr/local/opt/llvm/bin)
  if(CLANG_TIDY_EXE)
    message(STATUS "clang-tidy found: ${CLANG_TIDY_EXE}")
    set(
      CLANG_TIDY_CHECKS
      "-*,performance-for-range-copy,performance-unnecessary-copy-initialization,modernize-use-override,modernize-use-nullptr,modernize-loop-convert,modernize-use-bool-literals,modernize-deprecated-headers,misc-*,-misc-unused-parameters"
    )
    set(
      CMAKE_CXX_CLANG_TIDY
      "${CLANG_TIDY_EXE};-checks=${CLANG_TIDY_CHECKS};-header-filter='${CMAKE_SOURCE_DIR}/*'"
      CACHE STRING "" FORCE
    )
  else()
    message(AUTHOR_WARNING "clang-tidy not found!")
    set(CMAKE_CXX_CLANG_TIDY "" CACHE STRING "" FORCE) # delete it
  endif()
else()
  set(CMAKE_CXX_CLANG_TIDY "" CACHE STRING "" FORCE) # delete it
endif()

# Set extra warning flags in debug modes
set(
  CMAKE_CXX_FLAGS_RELWITHDEBINFO
  "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${CMAKE_CXX_FLAGS_WARN}"
)
set(
  CMAKE_CXX_FLAGS_DEBUG
  "${CMAKE_CXX_FLAGS_DEBUG} ${CMAKE_CXX_FLAGS_WARN} ${CMAKE_CXX_FLAGS_ERROR} ${SANITIZER_FLAGS}"
)
set(CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} ${SANITIZER_FLAGS}")
