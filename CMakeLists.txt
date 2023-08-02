cmake_minimum_required(VERSION 3.0)
cmake_policy(VERSION 3.0)

project(LearnOpenGL)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

IF(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build (Debug or Release)" FORCE)
ENDIF(NOT CMAKE_BUILD_TYPE)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules/")

link_directories(${CMAKE_SOURCE_DIR}/lib)

find_package(GLM REQUIRED)
message(STATUS "GLM included at ${GLM_INCLUDE_DIR}")
find_package(GLFW3 REQUIRED)
message(STATUS "Found GLFW3 in ${GLFW3_INCLUDE_DIR}")

if (APPLE)
    INCLUDE_DIRECTORIES(/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks)
    # FIND_LIBRARY(COCOA_LIBRARY Cocoa)
    FIND_LIBRARY(OpenGL_LIBRARY OpenGL)
    # FIND_LIBRARY(IOKit_LIBRARY IOKit)
    # FIND_LIBRARY(CoreVideo_LIBRARY CoreVideo)
    # MARK_AS_ADVANCED(COCOA_LIBRARY OpenGL_LIBRARY)
    # SET(APPLE_LIBS ${COCOA_LIBRARY} ${IOKit_LIBRARY} ${OpenGL_LIBRARY} ${CoreVideo_LIBRARY})
    # SET(APPLE_LIBS ${APPLE_LIBS} ${GLFW3_LIBRARY} ${ASSIMP_LIBRARY} ${FREETYPE_LIBRARIES})
    # set(LIBS ${LIBS} ${APPLE_LIBS})
    SET(APPLE_LIBS ${OpenGL_LIBRARY} )
    SET(APPLE_LIBS ${APPLE_LIBS} ${GLFW3_LIBRARY})
    
    set(LIBS ${LIBS} ${APPLE_LIBS})
endif(APPLE)

set(CHAPTERS
    Ch1-Getting_Started
)

set(Ch1-Getting_Started
    1.1.hello_window
    2.1.hello_triangle
    2.2.hello_triangle_indexed
    2.3.hello_triangle_exercise1
    2.4.hello_triangle_exercise2
    2.5.hello_triangle_exercise3
    3.1.shaders_uniform
    3.2.shaders_interpolation
    3.3.shaders_class
    3.4.shaders_exercise1
    3.5.shaders_exercise2
    3.6.shaders_exercise3
    4.1.textures
    4.2.textures_combined
    4.3.textures_exercise1
    4.4.textures_exercise2
    4.5.textures_exercise3
    4.6.textures_exercise4
    5.1.transformations
    5.2.transformations_exercise1
    5.2.transformations_exercise2
    6.1.coordinate_systems
    6.2.coordinate_systems_depth
    6.3.coordinate_systems_multiple
    6.4.coordinate_systems_exercise3
    7.1.camera_circle
    7.2.camera_keyboard_dt
    7.3.camera_mouse_zoom
    7.4.camera_class
    7.5.camera_exercise1
    7.6.camera_exercise2
    )

configure_file(configuration/root_directory.h.in configuration/root_directory.h)
include_directories(${CMAKE_BINARY_DIR}/configuration)

add_library(STB_IMAGE "src/stb_image.cpp")
set(LIBS ${LIBS} STB_IMAGE)

add_library(GLAD "src/glad.c")
set(LIBS ${LIBS} GLAD)

macro(makeLink src dest target)
  add_custom_command(TARGET ${target} POST_BUILD COMMAND ${CMAKE_COMMAND} -E create_symlink ${src} ${dest}  DEPENDS  ${dest} COMMENT "mklink ${src} -> ${dest}")
endmacro()

function(create_project_from_sources chapter demo)
    file(GLOB SOURCE
        "src/${chapter}/${demo}/*.h"
        "src/${chapter}/${demo}/*.cpp"
        "src/${chapter}/${demo}/*.vs"
        "src/${chapter}/${demo}/*.fs"
        "src/${chapter}/${demo}/*.vert"
        "src/${chapter}/${demo}/*.frag"
        "src/${chapter}/${demo}/*.tcs"
        "src/${chapter}/${demo}/*.tes"
        "src/${chapter}/${demo}/*.gs"
        "src/${chapter}/${demo}/*.cs"
    )
    if(demo STREQUAL "")
        SET(replaced "")
        string(REPLACE "/" "_" replaced ${chapter})
		set(NAME ${replaced})
    else()
        set(NAME "${chapter}__${demo}")
    endif()
    add_executable(${NAME} ${SOURCE})
    target_link_libraries(${NAME} ${LIBS})
    if(MSVC)
		target_compile_options(${NAME} PRIVATE /std:c++17 /MP)
        target_link_options(${NAME} PUBLIC /ignore:4099)
    endif(MSVC)
    if(APPLE)
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/${chapter}")
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/bin/${chapter}")
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/bin/${chapter}")
    endif(APPLE)

    file(GLOB SHADERS
        "src/${chapter}/${demo}/*.vs"
        "src/${chapter}/${demo}/*.vert"
        "src/${chapter}/${demo}/*.frag"
        "src/${chapter}/${demo}/*.fs"
        "src/${chapter}/${demo}/*.tcs"
        "src/${chapter}/${demo}/*.tes"
        "src/${chapter}/${demo}/*.gs"
        "src/${chapter}/${demo}/*.cs"
    )
    file(GLOB DLLS "dlls/*.dll")

    foreach(SHADER ${SHADERS})
        if(APPLE)
            get_filename_component(SHADERNAME ${SHADER} NAME)
            makeLink(${SHADER} ${CMAKE_SOURCE_DIR}/bin/${chapter}/${SHADERNAME} ${NAME})
        endif(APPLE)
    endforeach(SHADER)
    if(MSVC)
        configure_file(${CMAKE_SOURCE_DIR}/configuration/visualstudio.vcxproj.user.in ${CMAKE_CURRENT_BINARY_DIR}/${NAME}.vcxproj.user @ONLY)
    endif(MSVC)
endfunction()

foreach(CHAPTER ${CHAPTERS})
    foreach(DEMO ${${CHAPTER}})
        create_project_from_sources(${CHAPTER} ${DEMO})
    endforeach(DEMO)
endforeach(CHAPTER)

include_directories(${CMAKE_SOURCE_DIR}/includes)
