cmake_minimum_required(VERSION 3.0)
cmake_policy(VERSION 3.0)

project(learnopengl)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

find_package(GLFW3 REQUIRED)
message(STATUS "Found GLFW3 in ${GLFW3_INCLUDE_DIR}")
set(LIBS ${GLFW3_LIBRARY})

find_package(GLM REQUIRED)
message(STATUS "GLM included at ${GLM_INCLUDE_DIR}")

find_package(ASSIMP REQUIRED)
message(STATUS "Found ASSIMP in ${ASSIMP_INCLUDE_DIR}")
set(LIBS ${LIBS} ${ASSIMP_LIBRARY})

set(CHAPTERS
    ch1
    ch2
    ch3
    ch4
)

set(ch1
    1.1.hello_window
    2.1.hello_triangle
    2.2.hello_triangle_indexed
    2.3.hello_triangle_hw1
    2.4.hello_triangle_hw2
    2.5.hello_triangle_hw3
    3.1.shaders_uniform
    3.2.shaders_interpolation
    3.3.shaders_class
    3.4.shaders_hw1
    3.5.shaders_hw2
    3.6.shaders_hw3
    4.1.textures
    4.2.textures_combined
    4.3.textures_hw1
    4.4.textures_hw2
    4.5.textures_hw3
    4.6.textures_hw4
    5.1.transformations
    5.2.transformations_hw1
    5.3.transformations_hw2
    6.1.coordinate_systems
    6.2.coordinate_systems_depth
    6.3.coordinate_systems_multiple
    6.4.coordinate_systems_hw1
    7.1.camera_circle
    7.2.camera_keyboard_dt
    7.3.camera_mouse_zoom
    7.4.camera_class
    7.5.camera_hw1
    7.6.camera_hw2
)

set(ch2
    1.colors
    2.1.basic_lighting_diffuse
    2.2.basic_lighting_specular
    2.3.basic_lighting_hw1
    2.4.basic_lighting_hw2
    2.5.basic_lighting_hw3
    3.1.materials
    3.2.materials_hw1
    4.1.lighting_maps_diffuse_map
    4.2.lighting_maps_specular_map
    4.3.lighting_maps_hw2
    4.4.lighting_maps_hw3
    4.5.lighting_maps_hw4
    5.1.light_casters_directional
    5.2.light_casters_point
    5.3.light_casters_spot
    5.4.light_casters_spot_soft
    6.multiple_lights
    6.multiple_lights_desert
    6.multiple_lights_factory
    6.multiple_lights_horror
    6.multiple_lights_biochemical
)

set(ch3
    1.model_loading
)

set(ch4
    1.1.depth_testing
    1.2.depth_testing_view
    2.stencil_testing
    3.1.blending_discard
    3.2.blending_sort
    4.face_culling_hw
    5.1.framebuffers
    5.2.framebuffers_hw1
    6.1.cubemaps_skybox
    6.2.cubemaps_environment_mapping
    8.advanced_glsl_ubo
    9.1.geometry_shader_houses
    9.2.geometry_shader_exploding
    9.3.geometry_shader_normals
    10.1.instancing_quads
    10.2.asteroids
    10.3.asteroids_instanced
    11.1.anti_aliasing_msaa
    11.2.anti_aliasing_offscreen
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

    if(APPLE)
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin/${chapter}")
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_SOURCE_DIR}/bin/${chapter}")
        set_target_properties(${NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_SOURCE_DIR}/bin/${chapter}")
    endif(APPLE)

    file(GLOB SHADERS
        "src/${chapter}/${demo}/*.vs"
        "src/${chapter}/${demo}/*.fs"
        "src/${chapter}/${demo}/*.tcs"
        "src/${chapter}/${demo}/*.tes"
        "src/${chapter}/${demo}/*.gs"
        "src/${chapter}/${demo}/*.cs"
    )

    foreach(SHADER ${SHADERS})
        if(APPLE)
            get_filename_component(SHADERNAME ${SHADER} NAME)
            makeLink(${SHADER} ${CMAKE_SOURCE_DIR}/bin/${chapter}/${SHADERNAME} ${NAME})
        endif(APPLE)
    endforeach(SHADER)
endfunction()

foreach(CHAPTER ${CHAPTERS})
    foreach(DEMO ${${CHAPTER}})
        create_project_from_sources(${CHAPTER} ${DEMO})
    endforeach(DEMO)
endforeach(CHAPTER)

include_directories(${CMAKE_SOURCE_DIR}/includes /opt/homebrew/include)