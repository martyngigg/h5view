# Setup cppcheck if it exists on the system
find_package(cppcheck REQUIRED)

if(CPPCHECK_FOUND)
  set(_cppcheck_args "${CPPCHECK_ARGS}")
  set(
    _cppcheck_dirs
    **FILL
    IN
    DIRECTORIES
    THAT
    REQUIRE
    CHECKING**
  )
  set(_cppcheck_source_dirs)
  foreach(_dir ${_cppcheck_dirs})
    set(_tmpdir "${CMAKE_SOURCE_DIR}/${_dir}")
    if(EXISTS ${_tmpdir})
      list(APPEND _cppcheck_source_dirs ${_tmpdir})
    endif()
  endforeach()

  add_custom_target(
    cppcheck
    COMMAND
      ${CPPCHECK_EXECUTABLE}
      ${CPPCHECK_POSSIBLEERROR_ARG}
      ${CPPCHECK_UNUSEDFUNC_ARG}
      ${CPPCHECK_STYLE_ARG}
      ${CPPCHECK_QUIET_ARG}
      ${_cppcheck_source_dirs}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Running cppcheck"
  )
endif()
