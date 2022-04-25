#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "my_lib::my_lib" for configuration "Debug"
set_property(TARGET my_lib::my_lib APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(my_lib::my_lib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LOCATION_DEBUG "E:/learning/tools/cmake/cmake_practice/03_install_and_library/installation/lib/libmy_libd.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS my_lib::my_lib )
list(APPEND _IMPORT_CHECK_FILES_FOR_my_lib::my_lib "E:/learning/tools/cmake/cmake_practice/03_install_and_library/installation/lib/libmy_libd.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
