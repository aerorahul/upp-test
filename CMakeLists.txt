cmake_minimum_required(VERSION 3.15)

file(STRINGS "VERSION" pVersion LIMIT_COUNT 1)

project(
  upp
  VERSION ${pVersion}
  LANGUAGES Fortran)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMakeModules/Modules")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

option(OPENMP "use OpenMP threading" OFF)
option(BUILD_POSTEXEC "Build UPP stand-alone executable" ON)
option(BUILD_WITH_WRFLIB "Build UPP with WRF library" OFF)

if(NOT CMAKE_BUILD_TYPE MATCHES "^(Debug|Release|RelWithDebInfo|MinSizeRel)$")
  message(STATUS "Setting build type to 'Release' as none was specified.")
  set(CMAKE_BUILD_TYPE
      "Release"
      CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
                                               "MinSizeRel" "RelWithDebInfo")
endif()

if(NOT CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel|GNU|Clang|AppleClang)$")
  message(WARNING "Compiler not officially supported: ${CMAKE_Fortran_COMPILER_ID}")
endif()

find_package(MPI REQUIRED)
find_package(NetCDF REQUIRED COMPONENTS Fortran)

if(OPENMP)
  find_package(OpenMP REQUIRED COMPONENTS Fortran)
endif()

if(BUILD_WITH_WRFLIB)
  find_package(wrf REQUIRED)
else()
  set(wrf_FOUND FALSE)
endif()

find_package(w3nco REQUIRED)
find_package(g2 REQUIRED)
find_package(g2tmpl REQUIRED)
find_package(bacio REQUIRED)
find_package(ip REQUIRED)
find_package(sp REQUIRED)
find_package(w3emc REQUIRED)
find_package(crtm REQUIRED)

if(BUILD_POSTEXEC)
  find_package(sigio REQUIRED)
  find_package(sfcio REQUIRED)
  find_package(nemsio REQUIRED)
  find_package(gfsio REQUIRED)
endif()

include(upp_compiler_flags)

if(CMAKE_Fortran_COMPILER_ID MATCHES "^(Intel)$")
  set(CMAKE_Fortran_FLAGS
      "-g -traceback -fp-model source -free -convert big_endian")
  set(CMAKE_Fortran_FLAGS_RELEASE "-O3")
  set(CMAKE_Fortran_FLAGS_DEBUG "-O0")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "^(GNU|Clang|AppleClang)$")
  set(CMAKE_Fortran_FLAGS
      "-g -fbacktrace -ffree-form -ffree-line-length-none -fconvert=big-endian")
  set(CMAKE_Fortran_FLAGS_RELEASE "-O3")
  set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -ggdb -fno-unsafe-math-optimizations -frounding-math -fsignaling-nans -ffpe-trap=invalid,zero,overflow -fbounds-check")
endif()

add_subdirectory(libsrc)

if(BUILD_POSTEXEC)
  add_subdirectory(src)
endif()
