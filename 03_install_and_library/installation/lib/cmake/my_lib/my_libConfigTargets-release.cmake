#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "my_lib::my_lib" for configuration "Release"
set_property(TARGET my_lib::my_lib APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(my_lib::my_lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "CXX"
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libmy_lib.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS my_lib::my_lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_my_lib::my_lib "${_IMPORT_PREFIX}/lib/libmy_lib.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
