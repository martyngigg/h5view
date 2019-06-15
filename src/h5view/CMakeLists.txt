set(SRCS
  h5view.cpp
)

set(HEADERS
  h5view.hpp
)

add_library(h5view ${SRCS} ${HEADERS})
include(GenerateExportHeader)
generate_export_header(h5view)
target_include_directories(h5view PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

if(USE_CONAN)
  target_link_libraries(h5view PRIVATE ${CONDA_LIBS})
elseif(USE_CONDA)
  target_include_directories(h5view PRIVATE ${HDF5_INCLUDE_DIRS})
  target_link_libraries(h5view PUBLIC ${HDF5_CXX_LIBRARIES})
endif()
set_property(TARGET h5view
  APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../>
)
