cmake_minimum_required(VERSION 3.16)
set(CMAKE_OSX_DEPLOYMENT_TARGET "10.9" CACHE STRING "Minimum OS X deployment version")
project(MyPlugin)

set(PLUGIN_NAME ${PROJECT_NAME})
set(ADDITIONAL_PLUGIN_DISTRIBUTABLES README.md)
include(RackSDK.cmake)

add_library(${PLUGIN_NAME} STATIC src/MyModule.cpp)
target_link_libraries(${PLUGIN_NAME} LINK_PUBLIC RackSDK)

target_sources(${RACK_PLUGIN_LIB} PRIVATE src/plugin.cpp)
target_link_libraries(${RACK_PLUGIN_LIB} PRIVATE ${PLUGIN_NAME})


install(TARGETS ${RACK_PLUGIN_LIB} ${PLUGIN_NAME}
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib/static)
