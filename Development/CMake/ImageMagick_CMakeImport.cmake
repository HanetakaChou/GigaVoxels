#----------------------------------------------------------------
# Import library
#----------------------------------------------------------------

#----------------------------------------------------------------
# SET library PATH
#----------------------------------------------------------------

INCLUDE (GvSettings_CMakeImport)

#----------------------------------------------------------------
# Search for ImageMagick
#----------------------------------------------------------------

find_package (ImageMagick COMPONENTS Magick++ REQUIRED)
if (NOT ImageMagick_Magick++_FOUND)
	message (FATAL_ERROR "system doesn't have Magick++")
endif()

#----------------------------------------------------------------
# LINUX Operating System
#----------------------------------------------------------------

if (UNIX)

#----------------------------------------------------------------
# IMAGEMAGICK library settings
#----------------------------------------------------------------
set (GV_IMAGEMAGICK_INC "${ImageMagick_Magick++_INCLUDE_DIR}")
set (GV_IMAGEMAGICK_ARCH_INC "${ImageMagick_Magick++_ARCH_INCLUDE_DIR}")
set (GV_IMAGEMAGICK_LIB "${ImageMagick_Magick++_LIBRARY}")

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_IMAGEMAGICK_INC})
INCLUDE_DIRECTORIES (${GV_IMAGEMAGICK_ARCH_INC})

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

LINK_LIBRARIES(${GV_IMAGEMAGICK_LIB})

#----------------------------------------------------------------
# Magick++-config
#----------------------------------------------------------------
set(Magick++_CONFIG "/usr/lib/x86_64-linux-gnu/ImageMagick-6.9.10/bin-q16/Magick++-config")
if (NOT EXISTS "${Magick++_CONFIG}")
	message (FATAL_ERROR "system doesn't have Magick++-config")
endif()

execute_process(COMMAND "bash" "-c" "${Magick++_CONFIG} --cxxflags" OUTPUT_VARIABLE MAGICK++_CXX_FLAGS)
string(STRIP ${MAGICK++_CXX_FLAGS} MAGICK++_CXX_FLAGS)
string(REGEX MATCH "-DMAGICKCORE_HDRI_ENABLE=([0-9]*)" GV_MAGICKCORE_HDRI_ENABLE_FLAG "${MAGICK++_CXX_FLAGS}")
string(REGEX MATCH "-DMAGICKCORE_QUANTUM_DEPTH=([0-9]*)" GV_MAGICKCORE_QUANTUM_DEPTH_FLAG "${MAGICK++_CXX_FLAGS}")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${GV_MAGICKCORE_HDRI_ENABLE_FLAG} ${GV_MAGICKCORE_QUANTUM_DEPTH_FLAG}")

elseif (WIN32)

#----------------------------------------------------------------
# IMAGEMAGICK library settings
#----------------------------------------------------------------

set (GV_IMAGEMAGICK_INC "${ImageMagick_Magick++_INCLUDE_DIR}")
set (GV_IMAGEMAGICK_ARCH_INC "${ImageMagick_Magick++_ARCH_INCLUDE_DIR}")
set (GV_IMAGEMAGICK_LIB_DIR "${ImageMagick_EXECUTABLE_DIR}/lib")

#----------------------------------------------------------------
# Add INCLUDE library directories
#----------------------------------------------------------------

INCLUDE_DIRECTORIES (${GV_IMAGEMAGICK_INC})
INCLUDE_DIRECTORIES (${GV_IMAGEMAGICK_ARCH_INC})

#----------------------------------------------------------------
# Add LINK library directories
#----------------------------------------------------------------

LINK_DIRECTORIES (${GV_IMAGEMAGICK_LIB_DIR})

#----------------------------------------------------------------
# Set LINK libraries if not defined by user
#----------------------------------------------------------------

IF ( "${imagemagickLib}" STREQUAL "" )
	# Windows name of the library (CORE_RL_Magick++_.lib)
	IF ( ${GV_DESTINATION_ARCH} STREQUAL "x86" )
		SET (imagemagickLib "CORE_RL_Magick++_")
	ELSE ()
		SET (imagemagickLib "CORE_RL_Magick++_")
	ENDIF ()
ENDIF ()

#----------------------------------------------------------------
# Add LINK libraries
#----------------------------------------------------------------

FOREACH (it ${imagemagickLib})
	LINK_LIBRARIES (optimized ${it} debug ${it})
ENDFOREACH (it)

else (UNIX)

message (FATAL_ERROR "Unknown operating system ")

endif (UNIX)

