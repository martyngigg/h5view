#
# Build the documentation
#
find_package (Doxygen REQUIRED)

#
# Configure the script and the doxyfile, then add target
#
configure_file (${CMAKE_CURRENT_LIST_DIR}/doxyfile.in
  ${CMAKE_CURRENT_BINARY_DIR}/doxyfile
)

add_custom_target (doxygen
  ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/doxyfile
)
