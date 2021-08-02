#----------------------------------------------------------------
# Global GigaSpace Library Settings
#----------------------------------------------------------------

# Include guard
if (GvSettings_Included)
	return()
endif ()
set (GvSettings_Included true)

# Use colored output
set (CMAKE_COLOR_MAKEFILE ON)

# set(CMAKE_SKIP_RPATH TRUE)

#----------------------------------------------------------------
# Check architecture
#
# Note :
# CMAKE_SIZEOF_VOID_P is undefined if used before
# a call to the "project" command.
#----------------------------------------------------------------

IF ( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    SET (GV_DESTINATION_ARCH "x86")
ENDIF()
IF (CMAKE_SIZEOF_VOID_P EQUAL 8)
    SET ( GV_DESTINATION_ARCH "x64" )
ENDIF()

#----------------------------------------------------------------
# GigaSpace Settings
#----------------------------------------------------------------

# Set Third Party Dependencies path
IF ( ${GV_DESTINATION_ARCH} STREQUAL "x86" )
	SET (GV_EXTERNAL ${GV_ROOT}/External/${CMAKE_SYSTEM_NAME}/x86)
ENDIF()
IF ( ${GV_DESTINATION_ARCH} STREQUAL "x64" )
	SET (GV_EXTERNAL ${GV_ROOT}/External/${CMAKE_SYSTEM_NAME}/x64)
ENDIF()

# Set Main GigaSpace RELEASE directory
# It will contain all generated executables, demos, tools, etc...
SET (GV_RELEASE ${GV_ROOT}/Release)

#----------------------------------------------------------------
# Defines
#----------------------------------------------------------------

if (MSVC)
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)
	add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
	add_definitions(-DNOMINMAX)
endif ()

#----------------------------------------------------------------
# Search for CUDA
#----------------------------------------------------------------
find_package (CUDA REQUIRED)
if (NOT CUDA_FOUND)
	message (FATAL_ERROR "system doesn't have CUDA")
endif()

#----------------------------------------------------------------
# Options
#----------------------------------------------------------------

option ( GV_USE_64_BITS "Enable/disable compilation in 64 bits." ON )
if ( GV_USE_64_BITS )
    set ( GV_SYSTEM_PROCESSOR "x64" )
else()
	set ( GV_SYSTEM_PROCESSOR "x86" )
endif()

#----------------------------------------------------------------
# CUDA : additional NVCC command line arguments
# NOTE: multiple arguments must be semi-colon delimited (e.g. --compiler-options;-Wall)
#----------------------------------------------------------------

#list(APPEND CUDA_NVCC_FLAGS --keep-dir;"Debug")
#list(APPEND CUDA_NVCC_FLAGS --compile)
#list(APPEND CUDA_NVCC_FLAGS -maxrregcount=0)

# Set your compute capability version
#
# GigaVoxels requires 2.0 at least
#
# NOTE : choose if you want virtual mode or not with "gencode" and "arch" keywords.
# - you can also choose to embed several architectures.
#
# list(APPEND CUDA_NVCC_FLAGS -gencode=arch=compute_20,code=\"sm_20,compute_20\")
#
# list(APPEND CUDA_NVCC_FLAGS "-gencode=arch=compute_20,code=sm_20 -gencode=arch=compute_20,code=compute_20")
# list(APPEND CUDA_NVCC_FLAGS "-gencode=arch=compute_30,code=sm_30 -gencode=arch=compute_30,code=compute_30")
# list(APPEND CUDA_NVCC_FLAGS "-gencode=arch=compute_50,code=sm_50 -gencode=arch=compute_50,code=compute_50")
#
# list(APPEND CUDA_NVCC_FLAGS "-arch=sm_20")
# list(APPEND CUDA_NVCC_FLAGS "-arch=sm_21")
# list(APPEND CUDA_NVCC_FLAGS "-arch=sm_30")
# list(APPEND CUDA_NVCC_FLAGS "-arch=sm_32")
# list(APPEND CUDA_NVCC_FLAGS "-arch=sm_35")
# list(APPEND CUDA_NVCC_FLAGS "-arch=sm_37")
# list(APPEND CUDA_NVCC_FLAGS "-arch=sm_50")
# list(APPEND CUDA_NVCC_FLAGS "-arch=sm_52")

# NVCC verbose mode : set this flag to see detailed NVCC statistics (registers usage, memory, etc...)
# list(APPEND CUDA_NVCC_FLAGS -Xptxas;-v)

# Generate line-number information for device code
# list(APPEND CUDA_NVCC_FLAGS -lineinfo)

# Max nb registers
# list(APPEND CUDA_NVCC_FLAGS -maxrregcount=32)

# Use fast math
list(APPEND CUDA_NVCC_FLAGS -use_fast_math)

# NSight Debugging
# - debug on CPU
# list(APPEND CUDA_NVCC_FLAGS -g)
# - debug on GPU
# list(APPEND CUDA_NVCC_FLAGS -G)

# Set this flag to see detailed NVCC command lines
# set (CUDA_VERBOSE_BUILD "ON")

message (STATUS "CUDA NVCC info (command line) = ${CUDA_NVCC_FLAGS}")

#----------------------------------------------------------------
# PIC
#----------------------------------------------------------------
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")