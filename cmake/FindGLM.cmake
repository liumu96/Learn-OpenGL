SET(_glm_HEADER_SEARCH_DIRS
"/opt/homebrew/include"
"/usr/include"
"/usr/local/include"
"${CMAKE_SOURCE_DIR}/includes"
"C:/Program Files (x86)/glfw/include" 
)

SET(_glm_ENV_ROOT_DIR "$ENV{GLM_ROOT_DIR}")
IF(NOT GLM_ROOT_DIR AND _glm_ENV_ROOT_DIR)
    SET(GLM_ROOT_DIR ${_glm_ENV_ROOT_DIR})
ENDIF(NOT GLM_ROOT_DIR AND _glm_ENV_ROOT_DIR)

IF(GLM_ROOT_DIR)
    SET(_glm_HEADER_SEARCH_DIRS "${GLM_ROOT_DIR}"
    "${GLM_ROOT_DIR}/include"
    "${_glm_HEADER_SEARCH_DIRS}")
ENDIF(GLM_ROOT_DIR)

FIND_PATH(GLM_INCLUDE_DIR "glm/glm.hpp"
PATHS ${_glm_HEADER_SEARCH_DIRS})

INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(GLM DEFAULT_MSG
GLM_INCLUDE_DIR)


IF(GLM_FOUND)
    SET(GLM_INCLUDE_DIR "${GLM_INCLUDE_DIR}")
ENDIF(GLM_FOUND)