set(SRCS h5utils.cpp)

add_library(h5utils SHARED ${SRCS})
target_include_directories(
  h5utils
  PRIVATE ${CONAN_INCLUDE_DIRS_PYBIND11} ${CONAN_INCLUDE_DIRS_PYTHON}
)
target_link_libraries(h5utils PRIVATE h5view)
set_property(TARGET h5utils PROPERTY PREFIX "")
