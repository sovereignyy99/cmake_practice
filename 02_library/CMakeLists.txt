cmake_minimum_required(VERSION 3.10..3.21)

project(MyApp VERSION 0.1 LANGUAGES CXX)

#生成shared lib
#add_library(MyMath_so SHARED ${CMAKE_CURRENT_LIST_DIR}/my_lib/MyMath.cpp)
#target_include_directories(MyMath_so PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include)
#set_target_properties(MyMath_so PROPERTIES VERSION ${PROJECT_VERSION})

set(MY_MATH_SLIB OFF)

#生成shared lib
if (MY_MATH_SLIB)
    add_library(MyMath_a STATIC ${CMAKE_CURRENT_LIST_DIR}/my_lib/MyMath.cpp)
    target_include_directories(MyMath_a PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include)
endif ()

#生成可执行文件
#add_executable(myapp_so app.cpp)
#target_link_libraries(myapp_so MyMath_so)
#target_include_directories(myapp_so PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include)

add_executable(myapp_a app.cpp)
target_include_directories(myapp_a PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include)
if (NOT MY_MATH_SLIB)
    target_link_directories(myapp_a PRIVATE ${CMAKE_CURRENT_LIST_DIR}/my_lib)
endif ()
target_link_libraries(myapp_a MyMath_a)
