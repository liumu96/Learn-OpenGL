cmake_minimum_required(VERSION 3.15)
project(gl_start)

set(CMAKE_CXX_STANDARD 11)

# set header file path
# include_directories("/opt/homebrew/include")
include_directories("../includes")

# set GLFW3 compile lib path
add_library(glfw SHARED IMPORTED)
SET_TARGET_PROPERTIES(glfw PROPERTIES IMPORTED_LOCATION "/opt/homebrew/Cellar/glfw/3.3.8/lib/libglfw.3.3.dylib")

# compile glad lib
add_library(glad SHARED "glad.c")

# create executable file
add_executable(gl_start "./Ch1-Gettint_Started/4.1 textures/textures.cpp")
# add_executable(gl_start "main.cpp")

# link GLFW GLAD OPENGL
target_link_libraries(gl_start glfw glad "-framework OpenGL")

