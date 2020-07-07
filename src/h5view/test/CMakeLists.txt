set(TEST_SRCS
  h5viewtest.cpp
)

set(TEST_NAME h5view_test)
add_executable(${TEST_NAME} ${TEST_SRCS})
target_compile_options(${TEST_NAME} PRIVATE ${COVERAGE_CFLAGS})
target_link_libraries(${TEST_NAME} h5view ${GTEST_LIBS} ${COVERAGE_LIBS})
gtest_discover_tests(${TEST_NAME}
  # set a working directory so your project root so that you can find test data via paths relative to the project root
  WORKING_DIRECTORY ${PROJECT_DIR}
  PROPERTIES ENVIRONMENT "H5VIEW_DATA_DIR=${CMAKE_SOURCE_DIR}/testing/data"
)
