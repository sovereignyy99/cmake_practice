cmake_minimum_required(VERSION 3.10..3.21)

project(my_lib_example LANGUAGES CXX)

if (NOT TARGET my_lib)
    # Stand-alone build
    set(CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}/../installation")
    find_package(my_lib REQUIRED)
    message(STATUS "---#---: Stand-alone build with find_package() function.")
endif ()

add_executable(my_lib_example example.cpp)
target_link_libraries(my_lib_example my_lib::my_lib)
