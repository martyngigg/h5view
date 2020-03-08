# target
add_executable(h5viewer main.cpp)
target_link_libraries(h5viewer PRIVATE h5view)

# package
install(TARGETS h5viewer DESTINATION bin)

# testing
set(COVERAGE_EXECUTABLE ${CMAKE_BINARY_DIR}/pyvenv/bin/coverage)
if(ENABLE_COVERAGE)
  set(COVERAGE_ARGS run)
endif()
add_test(NAME h5viewer.test_main
  COMMAND ${COVERAGE_EXECUTABLE} run ${CMAKE_CURRENT_LIST_DIR}/test/test_main.py)
set_tests_properties(h5viewer.test_main PROPERTIES
  ENVIRONMENT "PYTHONPATH=${CMAKE_CURRENT_LIST_DIR}"
)
