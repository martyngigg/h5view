# Provides a function to declare Cxx-based tests based on a set of headers
set (CXXTEST_USE_PYTHON ON)
find_package (CxxTest REQUIRED)
include_directories (${CXXTEST_INCLUDE_DIR})

include (CMakeParseArguments)
# Main function to declare a set of tests.
#
# Arguments:
#   prefix - String prefixing all test executables
#   ARGN - A set of test headers defining the tests. They are assumed
#          to be in the current source directory
function (ADD_SINGERS_TESTS)
  set (options )
  set (oneValueArgs EXE_PREFIX)
  set (multiValueArgs LINK_LIBRARIES TEST_HEADERS)
  cmake_parse_arguments(ADD_SINGERS_TESTS "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN} )
  set (_prefix ${ADD_SINGERS_TESTS_EXE_PREFIX})
  foreach (_test_hdr ${ADD_SINGERS_TESTS_TEST_HEADERS})
    get_filename_component (_test_name ${_test_hdr} NAME_WE)
    set (_exe_name ${_prefix}-${_test_name})
    # This generates the test and adds it to ctest
    cxxtest_add_test ( ${_exe_name} ${_test_name}_test.cpp
      ${CMAKE_CURRENT_SOURCE_DIR}/${_test_hdr})
    target_link_libraries (${_exe_name} ${ADD_SINGERS_TESTS_LINK_LIBRARIES})
  endforeach ()
endfunction ()
