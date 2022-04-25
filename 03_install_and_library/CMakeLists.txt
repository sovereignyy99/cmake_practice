# Copyright(c) 2022 Distributed under the MIT License (http://opensource.org/licenses/MIT)

cmake_minimum_required(VERSION 3.10..3.21)

# ---------------------------------------------------------------------------------------
# Start project
# ---------------------------------------------------------------------------------------
include(cmake/utils.cmake)
include(cmake/ide.cmake)
my_lib_extract_version()

project(my_lib VERSION ${MY_LIB_VERSION} LANGUAGES CXX)
message(STATUS "Build my_lib: ${MY_LIB_VERSION}")

#configure_file(MyAppConfig.h.in MyAppConfig.h)


# ---------------------------------------------------------------------------------------
# set directory
# ---------------------------------------------------------------------------------------
include(GNUInstallDirs)
set(CMAKE_PREFIX_PATH "${CMAKE_CURRENT_LIST_DIR}/installation")
set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/installation")
#set(CMAKE_INSTALL_LIBDIR "${CMAKE_INSTALL_PREFIX}/lib")
#set(CMAKE_INSTALL_BINDIR "${CMAKE_INSTALL_PREFIX}/bin")
#set(CMAKE_INSTALL_INCLUDEDIR "${CMAKE_INSTALL_PREFIX}/include")

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose Release or Debug" FORCE)
endif ()


# ---------------------------------------------------------------------------------------
# Compiler config
# ---------------------------------------------------------------------------------------
if (NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 11)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
endif ()

# make sure __cplusplus is defined when using msvc and enable parallel build
if (MSVC)
    string(APPEND CMAKE_CXX_FLAGS " /Zc:__cplusplus /MP")
endif ()

set(CMAKE_CXX_EXTENSIONS OFF)
if (CMAKE_SYSTEM_NAME MATCHES "CYGWIN" OR CMAKE_SYSTEM_NAME MATCHES "MSYS")
    set(CMAKE_CXX_EXTENSIONS ON)
endif ()


# ---------------------------------------------------------------------------------------
# Options
# ---------------------------------------------------------------------------------------
option(MY_LIB_BUILD_ALL "Build all artifacts" OFF)

# example options
option(MY_LIB_BUILD_EXAMPLE "Build example" ON)
# testing options
option(MY_LIB_BUILD_TESTS "Build tests" OFF)
# bench options
option(MY_LIB_BUILD_BENCH "Build benchmarks (Requires https://github.com/google/benchmark.git to be installed)" OFF)

# sanitizer options
option(MY_LIB_SANITIZE_ADDRESS "Enable address sanitizer in tests" OFF)
# warning options
option(MY_LIB_BUILD_WARNINGS "Enable compiler warnings" OFF)

# install options
option(MY_LIB_INSTALL "Generate the install target" ON)
# app options
option(MY_LIB_BUILD_APP "Build app" OFF)


if (MY_LIB_BUILD_ALL AND MY_LIB_BUILD_TESTS)
    message(FATAL_ERROR "test fatal error.")
endif ()

find_package(Threads REQUIRED)
message(STATUS "Build type: " ${CMAKE_BUILD_TYPE})


# ---------------------------------------------------------------------------------------
# Static Lib
# ---------------------------------------------------------------------------------------
set(MY_LIB_SRCS src/my_lib/my_lib.cpp)
add_library(my_lib STATIC ${MY_LIB_SRCS} ${MY_LIB_ALL_HEADERS})
add_library(my_lib::my_lib ALIAS my_lib)

#target_compile_definitions(my_lib PUBLIC MY_LIB_COMPILED_LIB)
target_include_directories(my_lib
        PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>"  #build usage
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"      #user usage
        PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
        )
target_link_libraries(my_lib PUBLIC Threads::Threads)
my_lib_enable_warnings(my_lib)

set_target_properties(my_lib PROPERTIES VERSION ${MY_LIB_VERSION} SOVERSION ${MY_LIB_VERSION_MAJOR})
set_target_properties(my_lib PROPERTIES DEBUG_POSTFIX d)

# ---------------------------------------------------------------------------------------
# Shared Lib
# ---------------------------------------------------------------------------------------
#add_library(my_lib SHARED ${MY_LIB_SRCS} ${MY_LIB_ALL_HEADERS})


# ---------------------------------------------------------------------------------------
# Build binaries
# ---------------------------------------------------------------------------------------
if (MY_LIB_BUILD_EXAMPLE OR MY_LIB_BUILD_ALL)
    message(STATUS "Generating example(s)")
    add_subdirectory(example)
    my_lib_enable_warnings(example)
endif ()

if (MY_LIB_BUILD_APP OR MY_LIB_BUILD_ALL)
    message(STATUS "Generating app")
    add_executable(my_app ./src/app.cpp ./src/my_lib/my_lib.cpp)
    target_include_directories(my_app PRIVATE ${CMAKE_SOURCE_DIR}/include)
    my_lib_enable_warnings(my_app)
endif ()

if (MY_LIB_BUILD_TESTS OR MY_LIB_BUILD_ALL)
    message(STATUS "Generating tests")
    enable_testing()
    add_subdirectory(tests)
endif ()

if (MY_LIB_BUILD_BENCH OR MY_LIB_BUILD_ALL)
    message(STATUS "Generating benchmarks")
    add_subdirectory(bench)
endif ()


# ---------------------------------------------------------------------------------------
# Install
# ---------------------------------------------------------------------------------------
if (MY_LIB_INSTALL)
    message(STATUS "Generating install")

    set(project_config_in "${CMAKE_CURRENT_LIST_DIR}/cmake/my_libConfig.cmake.in")
    set(project_config_out "${CMAKE_CURRENT_BINARY_DIR}/my_libConfig.cmake")
    set(config_targets_file "my_libConfigTargets.cmake")
    set(version_config_file "${CMAKE_CURRENT_BINARY_DIR}/my_libConfigVersion.cmake")
    set(export_dest_dir "${CMAKE_INSTALL_LIBDIR}/cmake/my_lib")
    set(pkgconfig_install_dir "${CMAKE_INSTALL_LIBDIR}/pkgconfig")
    set(pkg_config "${CMAKE_BINARY_DIR}/${PROJECT_NAME}.pc")

    # ---------------------------------------------------------------------------------------
    # Include files
    # ---------------------------------------------------------------------------------------
    install(DIRECTORY include/ DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}" PATTERN)
    # install(DIRECTORY include/ DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}" PATTERN "*.h")
    install(TARGETS my_lib
            EXPORT my_lib
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
            ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            # PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
            # PRIVATE_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
            )

    # ---------------------------------------------------------------------------------------
    # Install pkg-config file
    # ---------------------------------------------------------------------------------------
    get_target_property(PKG_CONFIG_DEFINES my_lib INTERFACE_COMPILE_DEFINITIONS)
    string(REPLACE ";" " -D" PKG_CONFIG_DEFINES "${PKG_CONFIG_DEFINES}")
    string(CONCAT PKG_CONFIG_DEFINES "-D" "${PKG_CONFIG_DEFINES}")
    configure_file("cmake/${PROJECT_NAME}.pc.in" "${pkg_config}" @ONLY)
    install(FILES "${pkg_config}" DESTINATION "${pkgconfig_install_dir}")

    # ---------------------------------------------------------------------------------------
    # Install CMake config files
    # ---------------------------------------------------------------------------------------
    install(EXPORT my_lib DESTINATION ${export_dest_dir} NAMESPACE my_lib:: FILE ${config_targets_file})

    include(CMakePackageConfigHelpers)
    configure_package_config_file("${project_config_in}" "${project_config_out}"
            INSTALL_DESTINATION ${export_dest_dir})

    write_basic_package_version_file("${version_config_file}" COMPATIBILITY SameMajorVersion)
    install(FILES "${project_config_out}" "${version_config_file}" DESTINATION "${export_dest_dir}")

    # ---------------------------------------------------------------------------------------
    # Support creation of installable packages
    # ---------------------------------------------------------------------------------------
    include(cmake/my_libCPack.cmake)
endif ()

message(STATUS "---$---: CMAKE_PREFIX_PATH = ${CMAKE_PREFIX_PATH}")
message(STATUS "---$---: CMAKE_INSTALL_PREFIX = ${CMAKE_INSTALL_PREFIX}")
message(STATUS "---$---: CMAKE_INSTALL_LIBDIR = ${CMAKE_INSTALL_LIBDIR}")
message(STATUS "---$---: CMAKE_INSTALL_BINDIR = ${CMAKE_INSTALL_BINDIR}")
message(STATUS "---$---: CMAKE_INSTALL_INCLUDEDIR = ${CMAKE_INSTALL_INCLUDEDIR}")
