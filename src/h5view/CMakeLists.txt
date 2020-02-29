set(SRCS h5view.cpp)

set(HEADERS h5view.hpp)

add_library(h5view SHARED ${SRCS} ${HEADERS})
include(GenerateExportHeader)
generate_export_header(h5view)
target_include_directories(h5view PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(h5view PUBLIC CONAN_PKG::hdf5)
set_property(
  TARGET h5view
  APPEND
  PROPERTY
    INTERFACE_INCLUDE_DIRECTORIES
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../>
)

install(TARGETS h5view DESTINATION lib)


if(ENABLE_TESTING)
  add_subdirectory(test)
endif()

# Python bindings
add_subdirectory(python)
