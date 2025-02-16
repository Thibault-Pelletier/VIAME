# VIAME Internal Project
#
# Required symbols are:
#   VIAME_BUILD_PREFIX - where packages are built
#   VIAME_INSTALL_PREFIX - directory install target
#   VIAME_PACKAGES_DIR - location of git submodule packages
#   VIAME_ARGS_COMMON -
##

FormatPassdowns( "VIAME_ENABLE" VIAME_ENABLE_FLAGS )
FormatPassdowns( "VIAME_DISABLE" VIAME_DISABLE_FLAGS )
FormatPassdowns( "VIAME_BUILD" VIAME_BUILD_FLAGS )
FormatPassdowns( "VIAME_INSTALL" VIAME_INSTALL_FLAGS )
FormatPassdowns( "VIAME_DOWNLOAD" VIAME_DOWNLOAD_FLAGS )
FormatPassdowns( "VIAME_VERSION" VIAME_VERSION_FLAGS )

if( VIAME_ENABLE_MATLAB )
  FormatPassdowns( "Matlab" VIAME_MATLAB_FLAGS )
endif()

if( VIAME_ENABLE_PYTHON )
  set( VIAME_PYTHON_FLAGS
    # Backwards compatibility for sub-projects which use "PYTHON_" cmake
    # variables and the old find_package( PythonInterp ) commands instead
    # of the newer find Python. CMake fills in other python vars from exec.
    -DPython_EXECUTABLE:PATH=${Python_EXECUTABLE}
    -DPYTHON_EXECUTABLE:PATH=${PYTHON_EXECUTABLE} )
endif()

ExternalProject_Add(viame
  DEPENDS ${VIAME_PROJECT_LIST}
  PREFIX ${VIAME_BUILD_PREFIX}
  SOURCE_DIR ${CMAKE_SOURCE_DIR}
  BINARY_DIR ${VIAME_BUILD_PLUGINS_DIR}
  USES_TERMINAL_BUILD 1
  CMAKE_GENERATOR ${gen}
  CMAKE_CACHE_ARGS
    ${VIAME_ARGS_COMMON}
    ${VIAME_ARGS_fletch}
    ${VIAME_ARGS_kwiver}
    ${VIAME_ARGS_scallop_tk}
    ${VIAME_ARGS_ITK}
    ${VIAME_ENABLE_FLAGS}
    ${VIAME_DISABLE_FLAGS}
    ${VIAME_BUILD_FLAGS}
    ${VIAME_INSTALL_FLAGS}
    ${VIAME_DOWNLOAD_FLAGS}
    ${VIAME_VERSION_FLAGS}
    ${VIAME_MATLAB_FLAGS}
    ${VIAME_PYTHON_FLAGS}
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DVIAME_BUILD_DEPENDENCIES:BOOL=OFF
    -DVIAME_IN_SUPERBUILD:BOOL=ON
    -DVIAME_CREATE_INSTALLER:BOOL=${VIAME_CREATE_INSTALLER}
    -DVIAME_FIXUP_BUNDLE:BOOL=${VIAME_FIXUP_BUNDLE}
    -DVIAME_OPENCV_VERSION:STRING=${VIAME_OPENCV_VERSION}
    -DVIAME_PYTHON_VERSION:STRING=${VIAME_PYTHON_VERSION}
    -DVIAME_PYTORCH_VERSION:STRING=${VIAME_PYTORCH_VERSION}
    -DKWIVER_PYTHON_MAJOR_VERSION:STRING=${Python_VERSION_MAJOR}
    -DKWIVER_PYTHON_USE_SYS_PATH:BOOL=OFF
  INSTALL_DIR ${VIAME_INSTALL_PREFIX}
  )

#if ( VIAME_FORCEBUILD )
ExternalProject_Add_Step(viame forcebuild
  COMMAND ${CMAKE_COMMAND}
    -E remove ${VIAME_BUILD_PREFIX}/src/viame-stamp/viame-build
  COMMENT "Removing build stamp file for build update (forcebuild)."
  DEPENDEES configure
  DEPENDERS build
  ALWAYS 1
  )
#endif()
