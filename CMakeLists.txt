cmake_minimum_required(VERSION 3.0)
cmake_policy(VERSION 3.0)

project(learnopengl)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

find_package(GLFW3 REQUIRED)
message(STATUS "Found GLFW3 in ${GLFW3_INCLUDE_DIR}")

add_library(GLAD "${CMAKE_CURRENT_SOURCE_DIR}/src/glad.c")
set(LIBS ${LIBS} GLAD)

include_directories(${CMAKE_SOURCE_DIR}/includes /opt/homebrew/include)

# Add source files
set(SOURCES src/main.cpp)

# Add executable
add_executable(learnopengl ${SOURCES})

target_link_libraries(learnopengl ${LIBS})
