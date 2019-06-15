set(SRCS
  h5view.cpp
)

set(HEADERS
  h5view.hpp
)

add_library(h5view ${SRCS} ${HEADERS})
if(USE_CONAN)
  target_link_libraries(h5view PRIVATE hdf5_cpp hdf5)
endif()
set_property(TARGET h5view
  APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../>
)
