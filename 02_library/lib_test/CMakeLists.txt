cmake_minimum_required(VERSION 3.10..3.21)

project(LibTest VERSION 0.1 LANGUAGES CXX)

add_executable(TestLib_a my_test.cpp)
target_include_directories(TestLib_a PRIVATE ${CMAKE_CURRENT_LIST_DIR}/../include)
target_link_directories(TestLib_a PRIVATE ${CMAKE_CURRENT_LIST_DIR}/../my_lib)
target_link_libraries(TestLib_a MyMath_a)
