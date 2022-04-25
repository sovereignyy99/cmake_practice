# ---------------------------------------------------------------------------------------
# IDE support for headers
# ---------------------------------------------------------------------------------------
set(MY_LIB_HEADERS_DIR "../include")

file(GLOB MY_LIB_TOP_HEADERS "${MY_LIB_HEADERS_DIR}/my_lib/*.h")
set(MY_LIB_ALL_HEADERS ${MY_LIB_TOP_HEADERS})

source_group("Header Files\\my_lib" FILES ${MY_LIB_TOP_HEADERS})
